import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

import '../config/environment.dart';
import '../logging/log_service.dart';
import '../oauth/oauth_manager.dart';

final _logger = Logger('CamaraApiClient');

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );
  return dio;
});

final camaraApiClientProvider = Provider<CamaraApiClient>((ref) {
  final dio = ref.watch(dioProvider);
  final env = EnvironmentConfig.iohSandbox().environment;
  final oauthManager = ref.watch(oauthManagerProvider);
  final logService = ref.watch(logServiceProvider.notifier);
  return CamaraApiClient(
    dio: dio,
    environment: env,
    oauthManager: oauthManager,
    logService: logService,
  );
});

class CamaraApiClient {
  CamaraApiClient({
    required Dio dio,
    required Environment environment,
    required OAuthManager oauthManager,
    required LogService logService,
  })  : _dio = dio,
        _environment = environment,
        _oauthManager = oauthManager,
        _logService = logService {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _oauthManager.getAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );
  }

  final Dio _dio;
  final Environment _environment;
  final OAuthManager _oauthManager;
  final LogService _logService;

  Future<Response<dynamic>> post(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
  }) async {
    try {
      _logger.fine('POST $path');
      final response = await _dio.post<dynamic>(
        path,
        data: data == null ? null : jsonEncode(data),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            ...?headers,
          },
        ),
      );
      _logger.fine('POST $path -> ${response.statusCode}');
      return response;
    } on DioException catch (e) {
      _logger.warning('POST $path failed: ${e.message}');
      rethrow;
    }
  }

  Environment get environment => _environment;
}


