import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class QosProfilesCapability implements CamaraCapability {
  @override
  String get id => 'qos_profiles';

  @override
  String get title => 'QoS Profiles';

  @override
  String get description =>
      'Manage Quality of Service profiles using CAMARA QoS Profiles API.';

  @override
  CamaraApiCategory get category => CamaraApiCategory.communicationQuality;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

