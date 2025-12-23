import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class DeviceVisitLocationCapability implements CamaraCapability {
  @override
  String get id => 'device_visit_location';

  @override
  String get title => 'Device Visit Location';

  @override
  String get description =>
      'Track device visit locations using CAMARA Device Visit Location API.';

  @override
  CamaraApiCategory get category => CamaraApiCategory.locationServices;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

