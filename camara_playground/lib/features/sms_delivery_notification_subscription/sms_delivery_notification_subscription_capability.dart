import 'package:flutter/widgets.dart';

import '../../app/capability_registry.dart';

class SmsDeliveryNotificationSubscriptionCapability implements CamaraCapability {
  @override
  String get id => 'sms_delivery_notification_subscription';

  @override
  String get title => 'SMS Delivery Notification Subscription';

  @override
  String get description =>
      'Subscribe to SMS delivery notifications using CAMARA SMS Delivery Notification Subscription API.';

  @override
  CamaraApiCategory get category => CamaraApiCategory.communicationServices;

  @override
  bool get isSupportedByIOH => false;

  @override
  Widget buildEntryPoint(BuildContext context) {
    return const Placeholder();
  }
}

