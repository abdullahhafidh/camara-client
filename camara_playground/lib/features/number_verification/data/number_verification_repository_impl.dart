import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/logging/log_entry.dart';
import '../../../core/logging/log_service.dart';
import '../../../core/network/camara_api_client.dart';
import '../../../core/oauth/oauth_manager.dart';
import '../domain/entities.dart';
import '../domain/number_verification_repository.dart';

const _devicePhoneNumberChannel =
    MethodChannel('com.example.camara_playground/device_phone_number');

final numberVerificationRepositoryProvider =
    Provider<NumberVerificationRepository>((ref) {
  final client = ref.watch(camaraApiClientProvider);
  final oauth = ref.watch(oauthManagerProvider);
  final logService = ref.watch(logServiceProvider.notifier);
  return NumberVerificationRepositoryImpl(
    apiClient: client,
    oauthManager: oauth,
    logService: logService,
  );
});

class NumberVerificationRepositoryImpl implements NumberVerificationRepository {
  NumberVerificationRepositoryImpl({
    required CamaraApiClient apiClient,
    required OAuthManager oauthManager,
    required LogService logService,
  })  : _apiClient = apiClient,
        _oauthManager = oauthManager,
        _logService = logService;

  final CamaraApiClient _apiClient;
  final OAuthManager _oauthManager;
  final LogService _logService;

  @override
  Future<VerificationResult> verifyNumber(String claimedPhoneNumber) async {
    // Normalize MSISDN if needed; for now assume already in correct format.
    final url = _apiClient.environment.verifyMsisdnUrl;
    
    _logService.add(
      LogEntry(
        timestamp: DateTime.now(),
        source: 'NumberVerificationRepository',
        level: 'INFO',
        message: 'Calling verify-msisdn API',
        metadata: {
          'url': url,
          'msisdn': claimedPhoneNumber,
        },
        stepIndex: 6, // Will be overridden by controller if needed
        stepName: 'Verify Number',
      ),
    );
    
    try {
      final response = await _apiClient.post(
        url,
        data: {
          'msisdn': claimedPhoneNumber,
        },
      );
      
      final data = response.data as Map<String, dynamic>? ?? {};
      final match = (data['match'] as bool?) ?? true;
      final devicePhoneNumber = data['devicePhoneNumber'] as String?;
      final correlationId = data['correlationId'] as String?;
      
      _logService.add(
        LogEntry(
          timestamp: DateTime.now(),
          source: 'NumberVerificationRepository',
          level: 'INFO',
          message: 'verify-msisdn API response received',
          metadata: {
            'statusCode': response.statusCode,
            'match': match,
            'devicePhoneNumber': devicePhoneNumber,
            'correlationId': correlationId,
          },
          stepIndex: 6,
          stepName: 'Verify Number',
        ),
      );
      
      return VerificationResult(
        match: match,
        devicePhoneNumber: devicePhoneNumber,
        correlationId: correlationId,
      );
    } on DioException catch (e) {
      _logService.add(
        LogEntry(
          timestamp: DateTime.now(),
          source: 'NumberVerificationRepository',
          level: 'ERROR',
          message: 'verify-msisdn API call failed',
          metadata: {
            'error': e.message,
            'statusCode': e.response?.statusCode,
            'response': e.response?.data?.toString(),
          },
          stepIndex: 6,
          stepName: 'Verify Number',
        ),
      );
      rethrow;
    }
  }

  @override
  Future<DevicePhoneNumber> getDevicePhoneNumber() async {
    // Step 4 (manual) / Step 3 (auto): Get Automatic Phone Number from SIM
    _logService.add(
      LogEntry(
        timestamp: DateTime.now(),
        source: 'NumberVerificationRepository',
        level: 'INFO',
        message: 'Attempting to retrieve phone number from SIM card',
        stepIndex: 4, // Will be adjusted by controller
        stepName: 'Get Automatic Phone Number',
      ),
    );
    
    // First, on Android we try to read the MSISDN from the SIM via platform
    // channel. This is best-effort and may return null on many devices /
    // networks even if permissions are granted.
    try {
      final simNumber = await _devicePhoneNumberChannel
          .invokeMethod<String>('getDevicePhoneNumber');
      if (simNumber != null && simNumber.isNotEmpty) {
        _logService.add(
          LogEntry(
            timestamp: DateTime.now(),
            source: 'NumberVerificationRepository',
            level: 'INFO',
            message: 'Successfully retrieved phone number from SIM',
            metadata: {
              'phoneNumber': simNumber,
            },
            stepIndex: 4,
            stepName: 'Get Automatic Phone Number',
          ),
        );
        return DevicePhoneNumber(
          phoneNumber: simNumber,
          correlationId: null,
        );
      } else {
        _logService.add(
          LogEntry(
            timestamp: DateTime.now(),
            source: 'NumberVerificationRepository',
            level: 'WARN',
            message: 'SIM phone number not available, falling back to id_token',
            stepIndex: 4,
            stepName: 'Get Automatic Phone Number',
          ),
        );
      }
    } on PlatformException catch (e) {
      _logService.add(
        LogEntry(
          timestamp: DateTime.now(),
          source: 'NumberVerificationRepository',
          level: 'WARN',
          message: 'Failed to read SIM phone number, falling back to id_token',
          metadata: {
            'error': e.message,
            'code': e.code,
          },
          stepIndex: 4,
          stepName: 'Get Automatic Phone Number',
        ),
      );
    } on MissingPluginException {
      _logService.add(
        LogEntry(
          timestamp: DateTime.now(),
          source: 'NumberVerificationRepository',
          level: 'INFO',
          message: 'SIM access not available on this platform, using id_token',
          stepIndex: 4,
          stepName: 'Get Automatic Phone Number',
        ),
      );
    }

    // Step 5 (manual) / Step 4 (auto): Get Device Number from id_token
    _logService.add(
      LogEntry(
        timestamp: DateTime.now(),
        source: 'NumberVerificationRepository',
        level: 'INFO',
        message: 'Retrieving phone number from id_token',
        stepIndex: 5,
        stepName: 'Get Device Number',
      ),
    );
    
    // IOH flow primarily uses verify-msisdn; device phone number can also be
    // retrieved from id_token if present. For now we decode a simple JWT and
    // look for a "msisdn" claim.
    final idToken = await _oauthManager.getIdToken();
    if (idToken == null) {
      _logService.add(
        LogEntry(
          timestamp: DateTime.now(),
          source: 'NumberVerificationRepository',
          level: 'ERROR',
          message: 'id_token not available',
          stepIndex: 5,
          stepName: 'Get Device Number',
        ),
      );
      throw StateError('id_token not available');
    }
    
    // Very lightweight, non-validating JWT decode to extract payload.
    final parts = idToken.split('.');
    if (parts.length != 3) {
      _logService.add(
        LogEntry(
          timestamp: DateTime.now(),
          source: 'NumberVerificationRepository',
          level: 'ERROR',
          message: 'Invalid id_token format',
          metadata: {
            'partsCount': parts.length,
          },
          stepIndex: 5,
          stepName: 'Get Device Number',
        ),
      );
      throw StateError('Invalid id_token format');
    }
    
    final payload = parts[1];
    final normalized = base64Url.normalize(payload);
    final decoded = utf8.decode(base64Url.decode(normalized));
    final map = jsonDecode(decoded) as Map<String, dynamic>;
    final msisdn = map['msisdn'] as String?;
    
    if (msisdn == null) {
      _logService.add(
        LogEntry(
          timestamp: DateTime.now(),
          source: 'NumberVerificationRepository',
          level: 'ERROR',
          message: 'msisdn not present in id_token',
          metadata: {
            'availableClaims': map.keys.toList(),
          },
          stepIndex: 5,
          stepName: 'Get Device Number',
        ),
      );
      throw StateError('msisdn not present in id_token');
    }
    
    _logService.add(
      LogEntry(
        timestamp: DateTime.now(),
        source: 'NumberVerificationRepository',
        level: 'INFO',
        message: 'Successfully retrieved phone number from id_token',
        metadata: {
          'phoneNumber': msisdn,
          'correlationId': map['jti'],
        },
        stepIndex: 5,
        stepName: 'Get Device Number',
      ),
    );
    
    return DevicePhoneNumber(
      phoneNumber: msisdn,
      correlationId: map['jti'] as String?,
    );
  }
}


