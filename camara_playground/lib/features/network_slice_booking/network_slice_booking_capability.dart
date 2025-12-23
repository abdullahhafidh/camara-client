import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class NetworkSliceBookingCapability implements CamaraCapability {
  @override
  String get id => 'network_slice_booking';

  @override
  String get title => 'Network Slice Booking';

  @override
  String get description =>
      'Book network slices using CAMARA Network Slice Booking API.';

  @override
  CamaraApiCategory get category => CamaraApiCategory.communicationQuality;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

