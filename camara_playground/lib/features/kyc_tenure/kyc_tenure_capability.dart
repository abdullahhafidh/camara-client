import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class KycTenureCapability implements CamaraCapability {
  @override
  String get id => 'kyc_tenure';

  @override
  String get title => 'Know Your Customer Tenure';

  @override
  String get description =>
      'Get customer tenure information using CAMARA KYC Tenure API.';

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

