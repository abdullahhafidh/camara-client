import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class DedicatedNetworkProfilesCapability implements CamaraCapability {
  @override
  String get id => 'dedicated_network_profiles';

  @override
  String get title => 'Dedicated Network Profiles';

  @override
  String get description =>
      'Manage dedicated network profiles using CAMARA Dedicated Network Profiles API.';

  @override
  CamaraApiCategory get category => CamaraApiCategory.communicationQuality;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

