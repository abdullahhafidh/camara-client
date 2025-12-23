import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class SiteToCloudVpnCapability implements CamaraCapability {
  @override
  String get id => 'site_to_cloud_vpn';

  @override
  String get title => 'Site To Cloud VPN';

  @override
  String get description =>
      'Manage site-to-cloud VPN using CAMARA Site To Cloud VPN API.';

  @override
  CamaraApiCategory get category => CamaraApiCategory.computingServices;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

