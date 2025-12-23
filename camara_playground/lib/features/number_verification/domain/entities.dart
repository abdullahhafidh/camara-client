class VerificationResult {
  VerificationResult({
    required this.match,
    this.devicePhoneNumber,
    this.correlationId,
  });

  final bool match;
  final String? devicePhoneNumber;
  final String? correlationId;
}

class DevicePhoneNumber {
  DevicePhoneNumber({
    required this.phoneNumber,
    this.correlationId,
  });

  final String phoneNumber;
  final String? correlationId;
}


