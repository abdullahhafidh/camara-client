import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class DedicatedNetworkAccessesCapability implements CamaraCapability {
  @override
  String get id => 'dedicated_network_accesses';

  @override
  String get title => 'Dedicated Network Accesses';

  @override
  String get description =>
      'Manage dedicated network access using CAMARA Dedicated Network Accesses API.';

  @override
  CamaraApiCategory get category => CamaraApiCategory.communicationQuality;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

