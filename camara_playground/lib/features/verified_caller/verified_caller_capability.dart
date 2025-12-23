import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class VerifiedCallerCapability implements CamaraCapability {
  @override
  String get id => 'verified_caller';

  @override
  String get title => 'Verified Caller';

  @override
  String get description =>
      'Verify caller identity using CAMARA Verified Caller API.';

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

