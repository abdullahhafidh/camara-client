import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class KycMatchCapability implements CamaraCapability {
  @override
  String get id => 'kyc_match';

  @override
  String get title => 'Know Your Customer Match';

  @override
  String get description =>
      'Match customer information using CAMARA KYC Match API.';

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

