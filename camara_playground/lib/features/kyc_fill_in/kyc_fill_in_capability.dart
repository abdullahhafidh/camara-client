import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class KycFillInCapability implements CamaraCapability {
  @override
  String get id => 'kyc_fill_in';

  @override
  String get title => 'Know Your Customer Fill In';

  @override
  String get description =>
      'Placeholder for CAMARA KYC Fill-In capability. Implementation TBD.';

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


