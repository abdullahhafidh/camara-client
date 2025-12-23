import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class NumberRecyclingCapability implements CamaraCapability {
  @override
  String get id => 'number_recycling';

  @override
  String get title => 'Number Recycling';

  @override
  String get description =>
      'Check if a number has been recycled using CAMARA Number Recycling API.';

  @override
  CamaraApiCategory get category =>
      CamaraApiCategory.authenticationAndFraudPrevention;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

