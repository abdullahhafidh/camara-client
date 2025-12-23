import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class QosBookingAndAssignmentCapability implements CamaraCapability {
  @override
  String get id => 'qos_booking_and_assignment';

  @override
  String get title => 'QoS Booking and Assignment';

  @override
  String get description =>
      'Book and assign QoS using CAMARA QoS Booking and Assignment API.';

  @override
  CamaraApiCategory get category => CamaraApiCategory.communicationQuality;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

