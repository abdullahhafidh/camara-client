import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';
import 'presentation/number_verification_screen.dart';

class NumberVerificationCapability implements CamaraCapability {
  @override
  String get id => 'number_verification';

  @override
  String get title => 'Number Verification';

  @override
  String get description =>
      'Verify a claimed mobile number against the device using CAMARA Number Verification.';

  @override
  CamaraApiCategory get category =>
      CamaraApiCategory.authenticationAndFraudPrevention;

  @override
  bool get isSupportedByIOH => true;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const NumberVerificationScreen();
  }
}


