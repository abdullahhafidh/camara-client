import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class SimSwapSubscriptionsCapability implements CamaraCapability {
  @override
  String get id => 'sim_swap_subscriptions';

  @override
  String get title => 'SIM Swap Subscriptions';

  @override
  String get description =>
      'Subscribe to SIM swap notifications using CAMARA SIM Swap Subscriptions API.';

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

