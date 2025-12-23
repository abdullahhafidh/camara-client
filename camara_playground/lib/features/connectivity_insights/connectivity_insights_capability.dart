import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class ConnectivityInsightsCapability implements CamaraCapability {
  @override
  String get id => 'connectivity_insights';

  @override
  String get title => 'Connectivity Insights';

  @override
  String get description =>
      'Get connectivity insights using CAMARA Connectivity Insights API.';

  @override
  CamaraApiCategory get category => CamaraApiCategory.communicationQuality;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

