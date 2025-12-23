import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class BrandRegistrationCapability implements CamaraCapability {
  @override
  String get id => 'brand_registration';

  @override
  String get title => 'Brand Registration';

  @override
  String get description =>
      'Register brands for verification using CAMARA Brand Registration API.';

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

