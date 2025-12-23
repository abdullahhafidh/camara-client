import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class WebRTCEventSubscriptionCapability implements CamaraCapability {
  @override
  String get id => 'webrtc_event_subscription';

  @override
  String get title => 'WebRTC Event Subscription';

  @override
  String get description =>
      'Subscribe to WebRTC events using CAMARA WebRTC Event Subscription API.';

  @override
  CamaraApiCategory get category => CamaraApiCategory.communicationServices;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

