import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class PopulationDensityDataCapability implements CamaraCapability {
  @override
  String get id => 'population_density_data';

  @override
  String get title => 'Population Density Data';

  @override
  String get description =>
      'Get population density information using CAMARA Population Density Data API.';

  @override
  CamaraApiCategory get category => CamaraApiCategory.locationServices;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

