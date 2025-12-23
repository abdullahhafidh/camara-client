import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class DeviceLocationCapability implements CamaraCapability {
  @override
  String get id => 'device_location';

  @override
  String get title => 'Location Retrieval';

  @override
  String get description =>
      'Placeholder for CAMARA Location Retrieval capability. Implementation TBD.';

  @override
  CamaraApiCategory get category => CamaraApiCategory.locationServices;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}


