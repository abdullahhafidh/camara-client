import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class SubscriptionStatusCapability implements CamaraCapability {
  @override
  String get id => 'subscription_status';

  @override
  String get title => 'Subscription Status';

  @override
  String get description =>
      'Get subscription status using CAMARA Subscription Status API.';

  @override
  CamaraApiCategory get category => CamaraApiCategory.deviceInformation;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

