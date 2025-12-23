import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class MaasKnowledgeBaseCapability implements CamaraCapability {
  @override
  String get id => 'maas_knowledge_base';

  @override
  String get title => 'MaaS Knowledge Base';

  @override
  String get description =>
      'Model as a Service knowledge base using CAMARA MaaS Knowledge Base API.';

  @override
  CamaraApiCategory get category => CamaraApiCategory.computingServices;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

