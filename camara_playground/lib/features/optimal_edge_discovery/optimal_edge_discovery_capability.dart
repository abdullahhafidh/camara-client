import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class OptimalEdgeDiscoveryCapability implements CamaraCapability {
  @override
  String get id => 'optimal_edge_discovery';

  @override
  String get title => 'Optimal Edge Discovery';

  @override
  String get description =>
      'Discover optimal edge resources using CAMARA Optimal Edge Discovery API.';

  @override
  CamaraApiCategory get category => CamaraApiCategory.computingServices;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

