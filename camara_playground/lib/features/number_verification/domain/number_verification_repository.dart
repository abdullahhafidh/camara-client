import 'entities.dart';

abstract class NumberVerificationRepository {
  Future<VerificationResult> verifyNumber(String claimedPhoneNumber);
  Future<DevicePhoneNumber> getDevicePhoneNumber();
}


