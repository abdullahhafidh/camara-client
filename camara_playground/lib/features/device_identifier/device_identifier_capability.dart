import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class DeviceIdentifierCapability implements CamaraCapability {
  @override
  String get id => 'device_identifier';

  @override
  String get title => 'Device Identifier';

  @override
  String get description =>
      'Get device identifier using CAMARA Device Identifier API.';

  @override
  CamaraApiCategory get category => CamaraApiCategory.deviceInformation;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

