import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class EdgeApplicationManagementCapability implements CamaraCapability {
  @override
  String get id => 'edge_application_management';

  @override
  String get title => 'Edge Application Management';

  @override
  String get description =>
      'Manage edge applications using CAMARA Edge Application Management API.';

  @override
  CamaraApiCategory get category => CamaraApiCategory.computingServices;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

