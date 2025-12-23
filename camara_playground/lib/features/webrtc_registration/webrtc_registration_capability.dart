import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class WebRTCRegistrationCapability implements CamaraCapability {
  @override
  String get id => 'webrtc_registration';

  @override
  String get title => 'WebRTC Registration';

  @override
  String get description =>
      'Register for WebRTC services using CAMARA WebRTC Registration API.';

  @override
  CamaraApiCategory get category => CamaraApiCategory.communicationServices;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

