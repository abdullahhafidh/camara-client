import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class WebRTCCallHandlingCapability implements CamaraCapability {
  @override
  String get id => 'webrtc_call_handling';

  @override
  String get title => 'WebRTC Call Handling';

  @override
  String get description =>
      'Handle WebRTC calls using CAMARA WebRTC Call Handling API.';

  @override
  CamaraApiCategory get category => CamaraApiCategory.communicationServices;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

