import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class LocationVerificationCapability implements CamaraCapability {
  @override
  String get id => 'location_verification';

  @override
  String get title => 'Location Verification';

  @override
  String get description =>
      'Verify device location using CAMARA Location Verification API.';

  @override
  CamaraApiCategory get category => CamaraApiCategory.locationServices;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

