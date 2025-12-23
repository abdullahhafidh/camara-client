import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class KycAgeVerificationCapability implements CamaraCapability {
  @override
  String get id => 'kyc_age_verification';

  @override
  String get title => 'Know Your Customer Age Verification';

  @override
  String get description =>
      'Verify customer age using CAMARA KYC Age Verification API.';

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

