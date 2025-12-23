import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class SimSwapCapability implements CamaraCapability {
  @override
  String get id => 'sim_swap';

  @override
  String get title => 'SIM Swap';

  @override
  String get description =>
      'Placeholder for CAMARA SIM Swap capability. Implementation TBD.';

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


