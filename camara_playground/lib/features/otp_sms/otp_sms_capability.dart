import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class OtpSmsCapability implements CamaraCapability {
  @override
  String get id => 'otp_sms';

  @override
  String get title => 'One Time Password SMS';

  @override
  String get description =>
      'Send OTP via SMS using CAMARA One Time Password SMS API.';

  @override
  CamaraApiCategory get category =>
      CamaraApiCategory.authenticationAndFraudPrevention;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

