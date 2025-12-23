import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class ApplicationEndpointRegistrationCapability implements CamaraCapability {
  @override
  String get id => 'application_endpoint_registration';

  @override
  String get title => 'Application Endpoint Registration';

  @override
  String get description =>
      'Register application endpoints using CAMARA Application Endpoint Registration API.';

  @override
  CamaraApiCategory get category => CamaraApiCategory.computingServices;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

