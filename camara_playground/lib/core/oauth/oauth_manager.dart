import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:logging/logging.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/environment.dart';
import '../config/environment_manager.dart';
import '../logging/log_entry.dart';
import '../logging/log_service.dart';

final _logger = Logger('OAuthManager');

const _storage = FlutterSecureStorage();

/// Exception thrown when the user cancels the authorization flow.
class AuthorizationCancelledException implements Exception {
  AuthorizationCancelledException(this.message);

  final String message;

  @override
  String toString() => 'AuthorizationCancelledException: $message';
}

final oauthManagerProvider = Provider<OAuthManager>((ref) {
  final dio = Dio();
  final envState = ref.read(environmentManagerProvider);
  final env = envState.current.environment;
  final logService = ref.watch(logServiceProvider.notifier);
  return OAuthManager(
    dio: dio,
    environment: env,
    logService: logService,
  );
});

class OAuthManager {
  OAuthManager({
    required Dio dio,
    required Environment environment,
    required LogService logService,
  })  : _dio = dio,
        _environment = environment,
        _logService = logService;

  final Dio _dio;
  final Environment _environment;
  final LogService _logService;

  static const _keyAccessToken = 'oauth_access_token';
  static const _keyIdToken = 'oauth_id_token';

  String? _pendingCodeVerifier;

  /// Whether the current environment uses a redirect URI intended for
  /// web/backend flows (e.g. https://...), which requires a manual
  /// authorization code entry in the app.
  bool get requiresManualAuthorizationCodeFlow {
    final uri = Uri.parse(_environment.redirectUri);
    return uri.scheme == 'http' || uri.scheme == 'https';
  }

  /// Launches the operator authorization URL in an external browser.
  ///
  /// The user is expected to complete the flow in the browser and then
  /// manually copy the `code` from the callback page back into the app.
  Future<void> launchAuthorizationInBrowser() async {
    final state = _generateRandomString(32);
    final codeVerifier = _generateRandomString(64);
    _pendingCodeVerifier = codeVerifier;

    final codeChallenge = _codeChallenge(codeVerifier);
    final uri = Uri.parse(_environment.authorizeUrl).replace(
      queryParameters: {
        'state': state,
        'scope': _environment.scopes.join(' '),
        'client_id': _environment.clientId,
        'redirect_uri': _environment.redirectUri,
        'response_type': 'code',
        'code_challenge': codeChallenge,
        'code_challenge_method': 'S256',
      },
    );

    _logger.info('Launching authorize URL in external browser (state=$state)');
    
    _logService.add(
      LogEntry(
        timestamp: DateTime.now(),
        source: 'OAuthManager',
        level: 'INFO',
        message: 'Launching authorization URL in external browser',
        metadata: {
          'state': state,
          'authorizeUrl': _environment.authorizeUrl,
          'redirectUri': _environment.redirectUri,
          'clientId': _environment.clientId,
        },
        stepIndex: 1,
        stepName: 'Operator Consent',
      ),
    );

    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched) {
      _logger.severe('Failed to launch authorize URL in browser');
      _logService.add(
        LogEntry(
          timestamp: DateTime.now(),
          source: 'OAuthManager',
          level: 'ERROR',
          message: 'Failed to launch browser for authorization',
          stepIndex: 1,
          stepName: 'Operator Consent',
        ),
      );
      throw StateError('Could not launch browser for authorization');
    }
    
    _logService.add(
      LogEntry(
        timestamp: DateTime.now(),
        source: 'OAuthManager',
        level: 'INFO',
        message: 'Browser launched successfully',
        stepIndex: 1,
        stepName: 'Operator Consent',
      ),
    );
  }

  /// Starts an authorization flow that returns directly to the app via a
  /// mobile callback (custom scheme / app link) using flutter_web_auth_2.
  ///
  /// This is used when the operator/client configuration supports a mobile
  /// redirect URI that the app owns, so no manual code entry is required.
  Future<void> startAuthorizationFlowAutomatic() async {
    final state = _generateRandomString(32);
    final codeVerifier = _generateRandomString(64);

    final codeChallenge = _codeChallenge(codeVerifier);
    final uri = Uri.parse(_environment.authorizeUrl).replace(
      queryParameters: {
        'state': state,
        'scope': _environment.scopes.join(' '),
        'client_id': _environment.clientId,
        'redirect_uri': _environment.redirectUri,
        'response_type': 'code',
        'code_challenge': codeChallenge,
        'code_challenge_method': 'S256',
      },
    );

    _logger.info('Launching authorize URL with app callback (state=$state)');
    
    _logService.add(
      LogEntry(
        timestamp: DateTime.now(),
        source: 'OAuthManager',
        level: 'INFO',
        message: 'Starting automatic authorization flow',
        metadata: {
          'state': state,
          'authorizeUrl': _environment.authorizeUrl,
          'redirectUri': _environment.redirectUri,
        },
        stepIndex: 1,
        stepName: 'Operator Consent',
      ),
    );

    final callbackScheme = Uri.parse(_environment.redirectUri).scheme;

    try {
      final result = await FlutterWebAuth2.authenticate(
        url: uri.toString(),
        callbackUrlScheme: callbackScheme,
      );

      _logger.info('Received redirect from authorize endpoint');
      
      _logService.add(
        LogEntry(
          timestamp: DateTime.now(),
          source: 'OAuthManager',
          level: 'INFO',
          message: 'Received redirect from authorization endpoint',
          metadata: {
            'redirectUrl': result,
          },
          stepIndex: 2,
          stepName: 'Automatic Return',
        ),
      );

      final redirected = Uri.parse(result);
      final code = redirected.queryParameters['code'];
      final returnedState = redirected.queryParameters['state'];
      final error = redirected.queryParameters['error'];
      final errorDescription = redirected.queryParameters['error_description'];

      if (error != null) {
        _logger.warning('Authorization error: $error - $errorDescription');
        _logService.add(
          LogEntry(
            timestamp: DateTime.now(),
            source: 'OAuthManager',
            level: 'WARN',
            message: 'Authorization error from IdP',
            metadata: {
              'error': error,
              'errorDescription': errorDescription,
            },
            stepIndex: 1,
            stepName: 'Operator Consent',
          ),
        );
      }

      if (code == null || returnedState == null) {
        _logger.warning('Missing code or state on redirect');
        _logService.add(
          LogEntry(
            timestamp: DateTime.now(),
            source: 'OAuthManager',
            level: 'WARN',
            message: 'Missing code or state in redirect',
            metadata: {
              'hasCode': code != null,
              'hasState': returnedState != null,
            },
            stepIndex: 2,
            stepName: 'Automatic Return',
          ),
        );
        throw AuthorizationCancelledException('Missing code or state on redirect');
      }

      if (returnedState != state) {
        _logger.warning('State mismatch, ignoring redirect');
        _logService.add(
          LogEntry(
            timestamp: DateTime.now(),
            source: 'OAuthManager',
            level: 'WARN',
            message: 'State mismatch in redirect',
            metadata: {
              'expectedState': state,
              'returnedState': returnedState,
            },
            stepIndex: 2,
            stepName: 'Automatic Return',
          ),
        );
        throw AuthorizationCancelledException('State mismatch');
      }

      // For automatic flow, exchangeCodeForTokens is part of step 2 (Automatic Return)
      // We'll log with step 2, but controller will add more specific logs
      await _exchangeCodeForTokensWithStep(code, codeVerifier: codeVerifier, stepIndex: 2, stepName: 'Automatic Return');
    } catch (e) {
      // Check if this is a cancellation (flutter_web_auth_2 throws PlatformException
      // with code 'CANCELLED' or similar when user cancels)
      if (e is PlatformException) {
        final code = e.code.toLowerCase();
        if (code.contains('cancel') || code.contains('user_cancel')) {
          _logger.info('Authorization cancelled by user');
          _logService.add(
            LogEntry(
              timestamp: DateTime.now(),
              source: 'OAuthManager',
              level: 'INFO',
              message: 'Authorization cancelled by user',
              stepIndex: 1,
              stepName: 'Operator Consent',
            ),
          );
          _pendingCodeVerifier = null;
          throw AuthorizationCancelledException('User cancelled authorization');
        }
      }
      _logger.severe('Authorization flow failed: $e');
      _logService.add(
        LogEntry(
          timestamp: DateTime.now(),
          source: 'OAuthManager',
          level: 'ERROR',
          message: 'Authorization flow failed',
          metadata: {
            'error': e.toString(),
            'errorType': e.runtimeType.toString(),
          },
          stepIndex: 1,
          stepName: 'Operator Consent',
        ),
      );
      _pendingCodeVerifier = null;
      rethrow;
    }
  }

  /// Completes the authorization flow by exchanging a manually entered
  /// authorization `code` for tokens, using the previously generated
  /// PKCE code verifier.
  Future<void> completeAuthorizationWithCode(String code) async {
    _logService.add(
      LogEntry(
        timestamp: DateTime.now(),
        source: 'OAuthManager',
        level: 'INFO',
        message: 'Completing authorization with manual code',
        metadata: {
          'codeLength': code.length,
        },
        stepIndex: 3,
        stepName: 'Paste Code & Continue',
      ),
    );
    
    final verifier = _pendingCodeVerifier;
    if (verifier == null) {
      _logService.add(
        LogEntry(
          timestamp: DateTime.now(),
          source: 'OAuthManager',
          level: 'ERROR',
          message: 'No pending authorization flow found',
          stepIndex: 3,
          stepName: 'Paste Code & Continue',
        ),
      );
      throw StateError('No pending authorization flow. Launch it first.');
    }
    _pendingCodeVerifier = null;
    // For manual flow, exchangeCodeForTokens is part of step 3 (Paste Code & Continue)
    await _exchangeCodeForTokensWithStep(code, codeVerifier: verifier, stepIndex: 3, stepName: 'Paste Code & Continue');
  }

  /// Resets any pending authorization flow, allowing a fresh retry.
  void resetAuthorizationFlow() {
    _pendingCodeVerifier = null;
  }

  /// Internal method to exchange code for tokens with step information.
  Future<void> _exchangeCodeForTokensWithStep(
    String code, {
    required String codeVerifier,
    required int stepIndex,
    required String stepName,
  }) async {
    _logService.add(
      LogEntry(
        timestamp: DateTime.now(),
        source: 'OAuthManager',
        level: 'INFO',
        message: 'Exchanging authorization code for tokens',
        metadata: {
          'codeLength': code.length,
          'tokenUrl': _environment.tokenValidateUrl,
        },
        stepIndex: stepIndex,
        stepName: stepName,
      ),
    );
    
    try {
      _logger.info('Exchanging code for tokens');
      final response = await _dio.post<dynamic>(
        _environment.tokenValidateUrl,
        data: {
          'code': code,
          'code_verifier': codeVerifier,
          'redirect_uri': _environment.redirectUri,
          'client_id': _environment.clientId,
        },
        options: Options(
          headers: {
            'api-key': _environment.apiKey,
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );

      final json = response.data as Map<String, dynamic>;
      final accessToken = json['access_token'] as String?;
      final idToken = json['id_token'] as String?;

      if (accessToken != null) {
        await _storage.write(key: _keyAccessToken, value: accessToken);
      }
      if (idToken != null) {
        await _storage.write(key: _keyIdToken, value: idToken);
      }

      _logger.info('Token exchange successful');
      _logService.add(
        LogEntry(
          timestamp: DateTime.now(),
          source: 'OAuthManager',
          level: 'INFO',
          message: 'Token exchange completed successfully',
          metadata: {
            'hasAccessToken': accessToken != null,
            'hasIdToken': idToken != null,
          },
          stepIndex: stepIndex,
          stepName: stepName,
        ),
      );
    } on DioException catch (e) {
      _logger.severe('Token exchange failed: ${e.message}');
      _logService.add(
        LogEntry(
          timestamp: DateTime.now(),
          source: 'OAuthManager',
          level: 'ERROR',
          message: 'Token exchange failed',
          metadata: {
            'error': e.message,
            'statusCode': e.response?.statusCode,
            'response': e.response?.data?.toString(),
          },
          stepIndex: stepIndex,
          stepName: stepName,
        ),
      );
      rethrow;
    }
  }

  /// Exchanges an authorization code for tokens (public API, delegates to internal method).
  Future<void> exchangeCodeForTokens(
    String code, {
    required String codeVerifier,
  }) async {
    // Default to step 3 for backward compatibility, but should use _exchangeCodeForTokensWithStep
    await _exchangeCodeForTokensWithStep(code, codeVerifier: codeVerifier, stepIndex: 3, stepName: 'Paste Code & Continue');
  }

  Future<String?> getAccessToken() async {
    return _storage.read(key: _keyAccessToken);
  }

  Future<String?> getIdToken() async {
    return _storage.read(key: _keyIdToken);
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: _keyAccessToken);
    await _storage.delete(key: _keyIdToken);
  }

  String _generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random.secure();
    return List.generate(length, (_) => chars[rand.nextInt(chars.length)]).join();
  }

  String _codeChallenge(String verifier) {
    final bytes = utf8.encode(verifier);
    final digest = sha256.convert(bytes);
    return base64UrlEncode(digest.bytes).replaceAll('=', '');
  }
}


