import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class DeviceDataVolumeSubscriptionsCapability implements CamaraCapability {
  @override
  String get id => 'device_data_volume_subscriptions';

  @override
  String get title => 'Device Data Volume Subscriptions';

  @override
  String get description =>
      'Subscribe to data volume changes using CAMARA Device Data Volume Subscriptions API.';

  @override
  CamaraApiCategory get category => CamaraApiCategory.deviceInformation;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

