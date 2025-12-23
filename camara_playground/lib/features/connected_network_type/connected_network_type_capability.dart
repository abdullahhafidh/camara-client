import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class ConnectedNetworkTypeCapability implements CamaraCapability {
  @override
  String get id => 'connected_network_type';

  @override
  String get title => 'Connected Network Type';

  @override
  String get description =>
      'Get connected network type using CAMARA Connected Network Type API.';

  @override
  CamaraApiCategory get category => CamaraApiCategory.deviceInformation;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

