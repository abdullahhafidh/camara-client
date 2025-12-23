import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class MultiPointVpnCapability implements CamaraCapability {
  @override
  String get id => 'multi_point_vpn';

  @override
  String get title => 'Multi Point VPN';

  @override
  String get description =>
      'Manage multi-point VPN connections using CAMARA Multi Point VPN API.';

  @override
  CamaraApiCategory get category => CamaraApiCategory.communicationServices;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

