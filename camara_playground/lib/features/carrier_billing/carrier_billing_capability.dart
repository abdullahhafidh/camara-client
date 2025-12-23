import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class CarrierBillingCapability implements CamaraCapability {
  @override
  String get id => 'carrier_billing';

  @override
  String get title => 'Carrier Billing';

  @override
  String get description =>
      'Handle carrier billing using CAMARA Carrier Billing API.';

  @override
  CamaraApiCategory get category => CamaraApiCategory.paymentsAndCharging;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

