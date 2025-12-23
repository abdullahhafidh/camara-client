import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class HomeDevicesQodCapability implements CamaraCapability {
  @override
  String get id => 'home_devices_qod';

  @override
  String get title => 'Home Devices QoD';

  @override
  String get description =>
      'Quality on Demand for home devices using CAMARA Home Devices QoD API.';

  @override
  CamaraApiCategory get category => CamaraApiCategory.communicationQuality;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

