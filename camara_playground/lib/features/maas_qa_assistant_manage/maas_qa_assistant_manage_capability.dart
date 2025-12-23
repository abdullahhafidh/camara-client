import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class MaasQaAssistantManageCapability implements CamaraCapability {
  @override
  String get id => 'maas_qa_assistant_manage';

  @override
  String get title => 'MaaS QA Assistant Manage';

  @override
  String get description =>
      'Manage MaaS QA assistant using CAMARA MaaS QA Assistant Manage API.';

  @override
  CamaraApiCategory get category => CamaraApiCategory.computingServices;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

