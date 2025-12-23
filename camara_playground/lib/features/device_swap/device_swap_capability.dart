import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class DeviceSwapCapability implements CamaraCapability {
  @override
  String get id => 'device_swap';

  @override
  String get title => 'Device Swap';

  @override
  String get description =>
      'Detect and manage device swap events using CAMARA Device Swap API.';

  @override
  CamaraApiCategory get category =>
      CamaraApiCategory.authenticationAndFraudPrevention;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

