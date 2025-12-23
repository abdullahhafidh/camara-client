import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class DeviceRoamingStatusCapability implements CamaraCapability {
  @override
  String get id => 'device_roaming_status';

  @override
  String get title => 'Device Roaming Status';

  @override
  String get description =>
      'Get device roaming status using CAMARA Device Roaming Status API.';

  @override
  CamaraApiCategory get category => CamaraApiCategory.deviceInformation;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

