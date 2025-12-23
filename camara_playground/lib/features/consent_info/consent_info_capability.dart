import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class ConsentInfoCapability implements CamaraCapability {
  @override
  String get id => 'consent_info';

  @override
  String get title => 'Consent Info';

  @override
  String get description =>
      'Manage consent information using CAMARA Consent Info API.';

  @override
  CamaraApiCategory get category => CamaraApiCategory.serviceManagement;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

