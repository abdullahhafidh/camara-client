import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class ConnectedNetworkTypeSubscriptionsCapability implements CamaraCapability {
  @override
  String get id => 'connected_network_type_subscriptions';

  @override
  String get title => 'Connected Network Type Subscriptions';

  @override
  String get description =>
      'Subscribe to network type changes using CAMARA Connected Network Type Subscriptions API.';

  @override
  CamaraApiCategory get category => CamaraApiCategory.deviceInformation;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

