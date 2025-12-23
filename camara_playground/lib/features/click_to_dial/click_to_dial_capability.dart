import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class ClickToDialCapability implements CamaraCapability {
  @override
  String get id => 'click_to_dial';

  @override
  String get title => 'Click To Dial';

  @override
  String get description =>
      'Initiate click-to-dial calls using CAMARA Click To Dial API.';

  @override
  CamaraApiCategory get category => CamaraApiCategory.communicationServices;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

