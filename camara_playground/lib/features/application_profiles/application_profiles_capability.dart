import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class ApplicationProfilesCapability implements CamaraCapability {
  @override
  String get id => 'application_profiles';

  @override
  String get title => 'Application Profiles';

  @override
  String get description =>
      'Manage application profiles using CAMARA Application Profiles API.';

  @override
  CamaraApiCategory get category => CamaraApiCategory.communicationQuality;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

