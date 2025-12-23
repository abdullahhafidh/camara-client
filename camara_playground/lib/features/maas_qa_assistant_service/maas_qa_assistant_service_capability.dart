import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class MaasQaAssistantServiceCapability implements CamaraCapability {
  @override
  String get id => 'maas_qa_assistant_service';

  @override
  String get title => 'MaaS QA Assistant Service';

  @override
  String get description =>
      'MaaS QA assistant service using CAMARA MaaS QA Assistant Service API.';

  @override
  CamaraApiCategory get category => CamaraApiCategory.computingServices;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

