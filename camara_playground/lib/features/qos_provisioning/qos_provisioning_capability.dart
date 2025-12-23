import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class QosProvisioningCapability implements CamaraCapability {
  @override
  String get id => 'qos_provisioning';

  @override
  String get title => 'QoS Provisioning';

  @override
  String get description =>
      'Provision Quality of Service using CAMARA QoS Provisioning API.';

  @override
  CamaraApiCategory get category => CamaraApiCategory.communicationQuality;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

