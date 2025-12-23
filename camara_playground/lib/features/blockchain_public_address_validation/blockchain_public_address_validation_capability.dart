import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class BlockchainPublicAddressValidationCapability implements CamaraCapability {
  @override
  String get id => 'blockchain_public_address_validation';

  @override
  String get title => 'Blockchain Public Address Validation';

  @override
  String get description =>
      'Validate blockchain addresses using CAMARA Blockchain Public Address Validation API.';

  @override
  CamaraApiCategory get category => CamaraApiCategory.paymentsAndCharging;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

