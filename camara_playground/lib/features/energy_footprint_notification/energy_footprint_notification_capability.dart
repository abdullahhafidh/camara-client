import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class EnergyFootprintNotificationCapability implements CamaraCapability {
  @override
  String get id => 'energy_footprint_notification';

  @override
  String get title => 'Energy Footprint Notification';

  @override
  String get description =>
      'Get energy footprint notifications using CAMARA Energy Footprint Notification API.';

  @override
  CamaraApiCategory get category => CamaraApiCategory.computingServices;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

