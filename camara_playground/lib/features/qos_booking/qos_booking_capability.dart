import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class QosBookingCapability implements CamaraCapability {
  @override
  String get id => 'qos_booking';

  @override
  String get title => 'QoS Booking';

  @override
  String get description =>
      'Book Quality of Service using CAMARA QoS Booking API.';

  @override
  CamaraApiCategory get category => CamaraApiCategory.communicationQuality;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

