import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class BlockchainPublicAddressCapability implements CamaraCapability {
  @override
  String get id => 'blockchain_public_address';

  @override
  String get title => 'Blockchain Public Address';

  @override
  String get description =>
      'Manage blockchain public addresses using CAMARA Blockchain Public Address API.';

  @override
  CamaraApiCategory get category => CamaraApiCategory.paymentsAndCharging;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

