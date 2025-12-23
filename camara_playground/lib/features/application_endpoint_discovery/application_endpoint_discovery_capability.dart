import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class ApplicationEndpointDiscoveryCapability implements CamaraCapability {
  @override
  String get id => 'application_endpoint_discovery';

  @override
  String get title => 'Application Endpoint Discovery';

  @override
  String get description =>
      'Discover application endpoints using CAMARA Application Endpoint Discovery API.';

  @override
  CamaraApiCategory get category => CamaraApiCategory.computingServices;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

