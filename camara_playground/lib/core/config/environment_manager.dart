import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'environment.dart';

const _storage = FlutterSecureStorage();

const _currentEnvKey = 'env_current';
const _envHistoryKey = 'env_history';

/// Simple DTO for a versioned environment configuration.
class VersionedEnvironment {
  VersionedEnvironment({
    required this.id,
    required this.label,
    required this.environment,
    required this.version,
    required this.createdAt,
  });

  final String id;
  final String label;
  final Environment environment;
  final int version;
  final DateTime createdAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'version': version,
      'createdAt': createdAt.toIso8601String(),
      'environment': {
        'authorizeUrl': environment.authorizeUrl,
        'tokenValidateUrl': environment.tokenValidateUrl,
        'verifyMsisdnUrl': environment.verifyMsisdnUrl,
        'clientId': environment.clientId,
        'redirectUri': environment.redirectUri,
        'scopes': environment.scopes,
        'apiKey': environment.apiKey,
      },
    };
  }

  static VersionedEnvironment fromJson(Map<String, dynamic> json) {
    final env = json['environment'] as Map<String, dynamic>;
    return VersionedEnvironment(
      id: json['id'] as String,
      label: json['label'] as String,
      version: json['version'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      environment: Environment(
        authorizeUrl: env['authorizeUrl'] as String,
        tokenValidateUrl: env['tokenValidateUrl'] as String,
        verifyMsisdnUrl: env['verifyMsisdnUrl'] as String,
        clientId: env['clientId'] as String,
        redirectUri: env['redirectUri'] as String,
        scopes: (env['scopes'] as List<dynamic>).cast<String>(),
        apiKey: env['apiKey'] as String,
      ),
    );
  }
}

/// State for the environment manager.
class EnvironmentManagerState {
  const EnvironmentManagerState({
    required this.current,
    required this.history,
    required this.isLoading,
  });

  final VersionedEnvironment current;
  final List<VersionedEnvironment> history;
  final bool isLoading;

  EnvironmentManagerState copyWith({
    VersionedEnvironment? current,
    List<VersionedEnvironment>? history,
    bool? isLoading,
  }) {
    return EnvironmentManagerState(
      current: current ?? this.current,
      history: history ?? this.history,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Notifier that persists the current environment and its history.
class EnvironmentManager extends Notifier<EnvironmentManagerState> {
  @override
  EnvironmentManagerState build() {
    // Default to the built-in IOH sandbox, version 1.
    final builtIn = VersionedEnvironment(
      id: 'ioh_sandbox',
      label: 'IOH Sandbox',
      environment: EnvironmentConfig.iohSandbox().environment,
      version: 1,
      createdAt: DateTime.now(),
    );

    // Kick off async load to replace with any persisted state.
    _loadFromStorage();

    return EnvironmentManagerState(
      current: builtIn,
      history: const [],
      isLoading: true,
    );
  }

  Future<void> _loadFromStorage() async {
    try {
      final currentJson = await _storage.read(key: _currentEnvKey);
      final historyJson = await _storage.read(key: _envHistoryKey);

      VersionedEnvironment? current;
      List<VersionedEnvironment> history = [];

      if (currentJson != null) {
        final decoded = jsonDecode(currentJson) as Map<String, dynamic>;
        current = VersionedEnvironment.fromJson(decoded);
      }

      if (historyJson != null) {
        final decoded = jsonDecode(historyJson) as List<dynamic>;
        history = decoded
            .map((e) => VersionedEnvironment.fromJson(e as Map<String, dynamic>))
            .toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      }

      state = state.copyWith(
        current: current ?? state.current,
        history: history,
        isLoading: false,
      );
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Save a new version of the environment. The previous current version
  /// is appended to history.
  Future<void> saveNewVersion({
    required String label,
    required Environment environment,
  }) async {
    final previous = state.current;

    final next = VersionedEnvironment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      label: label,
      environment: environment,
      version: previous.version + 1,
      createdAt: DateTime.now(),
    );

    final updatedHistory = [
      previous,
      ...state.history,
    ];

    state = state.copyWith(
      current: next,
      history: updatedHistory,
    );

    await _persist(next, updatedHistory);
  }

  /// Revert to a historical version (this creates a new "current" version
  /// so that the timeline is always append-only).
  Future<void> revertTo(VersionedEnvironment target) async {
    final currentEnv = target.environment;
    await saveNewVersion(
      label: 'Revert to "${target.label}"',
      environment: currentEnv,
    );
  }

  Future<void> _persist(
    VersionedEnvironment current,
    List<VersionedEnvironment> history,
  ) async {
    final currentJson = jsonEncode(current.toJson());
    final historyJson =
        jsonEncode(history.map((e) => e.toJson()).toList(growable: false));

    await _storage.write(key: _currentEnvKey, value: currentJson);
    await _storage.write(key: _envHistoryKey, value: historyJson);
  }
}

/// Provider that exposes the environment manager state.
final environmentManagerProvider =
    NotifierProvider<EnvironmentManager, EnvironmentManagerState>(
  EnvironmentManager.new,
);


