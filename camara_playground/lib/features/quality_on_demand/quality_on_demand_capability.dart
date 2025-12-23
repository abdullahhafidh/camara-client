import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class QualityOnDemandCapability implements CamaraCapability {
  @override
  String get id => 'quality_on_demand';

  @override
  String get title => 'Quality on Demand';

  @override
  String get description =>
      'Request quality on demand using CAMARA Quality on Demand API.';

  @override
  CamaraApiCategory get category => CamaraApiCategory.communicationQuality;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

