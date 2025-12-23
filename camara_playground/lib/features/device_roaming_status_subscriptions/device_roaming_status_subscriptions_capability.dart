import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class DeviceRoamingStatusSubscriptionsCapability implements CamaraCapability {
  @override
  String get id => 'device_roaming_status_subscriptions';

  @override
  String get title => 'Device Roaming Status Subscriptions';

  @override
  String get description =>
      'Subscribe to roaming status changes using CAMARA Device Roaming Status Subscriptions API.';

  @override
  CamaraApiCategory get category => CamaraApiCategory.deviceInformation;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

