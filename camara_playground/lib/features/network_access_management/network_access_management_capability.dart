import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class NetworkAccessManagementCapability implements CamaraCapability {
  @override
  String get id => 'network_access_management';

  @override
  String get title => 'Network Access Management';

  @override
  String get description =>
      'Manage network access using CAMARA Network Access Management API.';

  @override
  CamaraApiCategory get category => CamaraApiCategory.deviceInformation;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

