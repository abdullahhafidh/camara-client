import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class CallForwardingSignalCapability implements CamaraCapability {
  @override
  String get id => 'call_forwarding_signal';

  @override
  String get title => 'Call Forwarding Signal';

  @override
  String get description =>
      'Signal call forwarding events using CAMARA Call Forwarding Signal API.';

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

