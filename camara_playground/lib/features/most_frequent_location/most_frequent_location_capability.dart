import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class MostFrequentLocationCapability implements CamaraCapability {
  @override
  String get id => 'most_frequent_location';

  @override
  String get title => 'Most Frequent Location';

  @override
  String get description =>
      'Get most frequent location using CAMARA Most Frequent Location API.';

  @override
  CamaraApiCategory get category => CamaraApiCategory.locationServices;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

