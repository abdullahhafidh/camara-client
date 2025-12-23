import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class PredictiveConnectivityDataCapability implements CamaraCapability {
  @override
  String get id => 'predictive_connectivity_data';

  @override
  String get title => 'Predictive Connectivity Data';

  @override
  String get description =>
      'Get predictive connectivity data using CAMARA Predictive Connectivity Data API.';

  @override
  CamaraApiCategory get category => CamaraApiCategory.communicationQuality;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

