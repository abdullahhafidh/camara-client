import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class DedicatedNetworkCapability implements CamaraCapability {
  @override
  String get id => 'dedicated_network';

  @override
  String get title => 'Dedicated Network';

  @override
  String get description =>
      'Manage dedicated networks using CAMARA Dedicated Network API.';

  @override
  CamaraApiCategory get category => CamaraApiCategory.communicationQuality;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

