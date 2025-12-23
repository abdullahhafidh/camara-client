import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class RegionDeviceCountCapability implements CamaraCapability {
  @override
  String get id => 'region_device_count';

  @override
  String get title => 'Region Device Count';

  @override
  String get description =>
      'Get device count in a region using CAMARA Region Device Count API.';

  @override
  CamaraApiCategory get category => CamaraApiCategory.locationServices;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

