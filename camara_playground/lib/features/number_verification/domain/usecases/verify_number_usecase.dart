import '../entities.dart';
import '../number_verification_repository.dart';

class VerifyNumberUseCase {
  VerifyNumberUseCase(this._repository);

  final NumberVerificationRepository _repository;

  Future<VerificationResult> call(String claimedPhoneNumber) {
    return _repository.verifyNumber(claimedPhoneNumber);
  }
}


