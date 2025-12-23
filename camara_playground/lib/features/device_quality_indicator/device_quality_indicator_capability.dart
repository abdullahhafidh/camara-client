import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class DeviceQualityIndicatorCapability implements CamaraCapability {
  @override
  String get id => 'device_quality_indicator';

  @override
  String get title => 'Device Quality Indicator';

  @override
  String get description =>
      'Get device quality indicators using CAMARA Device Quality Indicator API.';

  @override
  CamaraApiCategory get category => CamaraApiCategory.deviceInformation;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

