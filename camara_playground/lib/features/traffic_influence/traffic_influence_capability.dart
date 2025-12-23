import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class TrafficInfluenceCapability implements CamaraCapability {
  @override
  String get id => 'traffic_influence';

  @override
  String get title => 'Traffic Influence';

  @override
  String get description =>
      'Influence network traffic using CAMARA Traffic Influence API.';

  @override
  CamaraApiCategory get category => CamaraApiCategory.communicationQuality;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

