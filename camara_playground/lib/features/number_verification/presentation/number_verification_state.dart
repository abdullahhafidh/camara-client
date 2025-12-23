import '../domain/entities.dart';

enum NumberVerificationStatus {
  idle,
  authorizing,
  verifying,
  success,
  error,
}

class NumberVerificationState {
  const NumberVerificationState({
    this.status = NumberVerificationStatus.idle,
    this.devicePhoneNumber,
    this.authorizationCode = '',
    this.result,
    this.errorMessage,
    this.browserLaunched = false,
  });

  final NumberVerificationStatus status;
  final String? devicePhoneNumber;
  final String authorizationCode;
  final VerificationResult? result;
  final String? errorMessage;
  final bool browserLaunched;

  NumberVerificationState copyWith({
    NumberVerificationStatus? status,
    String? devicePhoneNumber,
    String? authorizationCode,
    VerificationResult? result,
    String? errorMessage,
    bool? browserLaunched,
  }) {
    return NumberVerificationState(
      status: status ?? this.status,
      devicePhoneNumber: devicePhoneNumber ?? this.devicePhoneNumber,
      authorizationCode: authorizationCode ?? this.authorizationCode,
      result: result ?? this.result,
      errorMessage: errorMessage ?? this.errorMessage,
      browserLaunched: browserLaunched ?? this.browserLaunched,
    );
  }
}


