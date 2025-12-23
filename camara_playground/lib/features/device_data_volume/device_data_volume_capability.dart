import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class DeviceDataVolumeCapability implements CamaraCapability {
  @override
  String get id => 'device_data_volume';

  @override
  String get title => 'Device Data Volume';

  @override
  String get description =>
      'Get device data volume using CAMARA Device Data Volume API.';

  @override
  CamaraApiCategory get category => CamaraApiCategory.deviceInformation;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

