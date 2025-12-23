import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class ConnectivityInsightsSubscriptionsCapability implements CamaraCapability {
  @override
  String get id => 'connectivity_insights_subscriptions';

  @override
  String get title => 'Connectivity Insights Subscriptions';

  @override
  String get description =>
      'Subscribe to connectivity insights using CAMARA Connectivity Insights Subscriptions API.';

  @override
  CamaraApiCategory get category => CamaraApiCategory.communicationQuality;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

