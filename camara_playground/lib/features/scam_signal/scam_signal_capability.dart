import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class ScamSignalCapability implements CamaraCapability {
  @override
  String get id => 'scam_signal';

  @override
  String get title => 'Scam Signal';

  @override
  String get description =>
      'Detect and signal scam attempts using CAMARA Scam Signal API.';

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

