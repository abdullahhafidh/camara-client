import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class CapabilitiesAndRuntimeRestrictionsCapability implements CamaraCapability {
  @override
  String get id => 'capabilities_and_runtime_restrictions';

  @override
  String get title => 'Capabilities And Runtime Restrictions';

  @override
  String get description =>
      'Manage capabilities and restrictions using CAMARA Capabilities And Runtime Restrictions API.';

  @override
  CamaraApiCategory get category => CamaraApiCategory.serviceManagement;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

