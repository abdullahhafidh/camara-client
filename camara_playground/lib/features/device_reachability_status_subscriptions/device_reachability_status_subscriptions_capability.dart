import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class DeviceReachabilityStatusSubscriptionsCapability implements CamaraCapability {
  @override
  String get id => 'device_reachability_status_subscriptions';

  @override
  String get title => 'Device Reachability Status Subscriptions';

  @override
  String get description =>
      'Subscribe to reachability changes using CAMARA Device Reachability Status Subscriptions API.';

  @override
  CamaraApiCategory get category => CamaraApiCategory.deviceInformation;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

