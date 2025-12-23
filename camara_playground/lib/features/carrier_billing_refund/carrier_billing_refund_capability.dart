import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class CarrierBillingRefundCapability implements CamaraCapability {
  @override
  String get id => 'carrier_billing_refund';

  @override
  String get title => 'Carrier Billing Refund';

  @override
  String get description =>
      'Process carrier billing refunds using CAMARA Carrier Billing Refund API.';

  @override
  CamaraApiCategory get category => CamaraApiCategory.paymentsAndCharging;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

