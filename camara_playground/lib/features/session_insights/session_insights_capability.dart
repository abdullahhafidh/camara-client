import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class SessionInsightsCapability implements CamaraCapability {
  @override
  String get id => 'session_insights';

  @override
  String get title => 'Session Insights';

  @override
  String get description =>
      'Get session insights using CAMARA Session Insights API.';

  @override
  CamaraApiCategory get category => CamaraApiCategory.communicationQuality;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

