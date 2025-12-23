import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class GeofencingSubscriptionsCapability implements CamaraCapability {
  @override
  String get id => 'geofencing_subscriptions';

  @override
  String get title => 'Geofencing Subscriptions';

  @override
  String get description =>
      'Subscribe to geofencing events using CAMARA Geofencing Subscriptions API.';

  @override
  CamaraApiCategory get category => CamaraApiCategory.locationServices;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

