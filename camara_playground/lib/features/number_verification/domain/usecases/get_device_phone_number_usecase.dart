import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

import '../entities.dart';
import '../number_verification_repository.dart';

class GetDevicePhoneNumberUseCase {
  GetDevicePhoneNumberUseCase(this._repository);

  final NumberVerificationRepository _repository;

  /// Attempts to retrieve the device phone number.
  ///
  /// On Android, this will first request the `phone` permission so that the
  /// SIM MSISDN can be read. On other platforms, it falls back directly to the
  /// repository implementation (which currently uses the `id_token`).
  Future<DevicePhoneNumber> call() async {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      final status = await Permission.phone.request();
      if (!status.isGranted) {
        throw StateError('Phone permission not granted');
      }
    }

    return _repository.getDevicePhoneNumber();
  }
}


