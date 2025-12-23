import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class SimpleEdgeDiscoveryCapability implements CamaraCapability {
  @override
  String get id => 'simple_edge_discovery';

  @override
  String get title => 'Simple Edge Discovery';

  @override
  String get description =>
      'Discover edge computing resources using CAMARA Simple Edge Discovery API.';

  @override
  CamaraApiCategory get category => CamaraApiCategory.computingServices;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

