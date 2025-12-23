import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class CustomerInsightsCapability implements CamaraCapability {
  @override
  String get id => 'customer_insights';

  @override
  String get title => 'Customer Insights';

  @override
  String get description =>
      'Get customer insights and analytics using CAMARA Customer Insights API.';

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

