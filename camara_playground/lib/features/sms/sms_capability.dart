import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class SmsCapability implements CamaraCapability {
  @override
  String get id => 'sms';

  @override
  String get title => 'SMS';

  @override
  String get description =>
      'Send SMS messages using CAMARA SMS API.';

  @override
  CamaraApiCategory get category => CamaraApiCategory.communicationServices;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

