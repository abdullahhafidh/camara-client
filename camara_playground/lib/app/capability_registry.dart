import 'package:flutter/widgets.dart';

// Authentication and Fraud Prevention
import '../features/brand_registration/brand_registration_capability.dart';
import '../features/call_forwarding_signal/call_forwarding_signal_capability.dart';
import '../features/customer_insights/customer_insights_capability.dart';
import '../features/device_swap/device_swap_capability.dart';
import '../features/kyc_age_verification/kyc_age_verification_capability.dart';
import '../features/kyc_fill_in/kyc_fill_in_capability.dart';
import '../features/kyc_match/kyc_match_capability.dart';
import '../features/kyc_tenure/kyc_tenure_capability.dart';
import '../features/number_recycling/number_recycling_capability.dart';
import '../features/number_verification/number_verification_capability.dart';
import '../features/otp_sms/otp_sms_capability.dart';
import '../features/scam_signal/scam_signal_capability.dart';
import '../features/sim_swap/sim_swap_capability.dart';
import '../features/sim_swap_subscriptions/sim_swap_subscriptions_capability.dart';
import '../features/verified_caller/verified_caller_capability.dart';

// Location Services
import '../features/device_location/device_location_capability.dart';
import '../features/device_visit_location/device_visit_location_capability.dart';
import '../features/geofencing_subscriptions/geofencing_subscriptions_capability.dart';
import '../features/location_verification/location_verification_capability.dart';
import '../features/most_frequent_location/most_frequent_location_capability.dart';
import '../features/population_density_data/population_density_data_capability.dart';
import '../features/region_device_count/region_device_count_capability.dart';

// Communication Services
import '../features/click_to_dial/click_to_dial_capability.dart';
import '../features/multi_point_vpn/multi_point_vpn_capability.dart';
import '../features/sms/sms_capability.dart';
import '../features/sms_delivery_notification_subscription/sms_delivery_notification_subscription_capability.dart';
import '../features/webrtc_call_handling/webrtc_call_handling_capability.dart';
import '../features/webrtc_event_subscription/webrtc_event_subscription_capability.dart';
import '../features/webrtc_registration/webrtc_registration_capability.dart';

// Communication Quality
import '../features/application_profiles/application_profiles_capability.dart';
import '../features/connectivity_insights/connectivity_insights_capability.dart';
import '../features/connectivity_insights_subscriptions/connectivity_insights_subscriptions_capability.dart';
import '../features/dedicated_network/dedicated_network_capability.dart';
import '../features/dedicated_network_accesses/dedicated_network_accesses_capability.dart';
import '../features/dedicated_network_profiles/dedicated_network_profiles_capability.dart';
import '../features/home_devices_qod/home_devices_qod_capability.dart';
import '../features/network_slice_booking/network_slice_booking_capability.dart';
import '../features/predictive_connectivity_data/predictive_connectivity_data_capability.dart';
import '../features/qos_booking/qos_booking_capability.dart';
import '../features/qos_booking_and_assignment/qos_booking_and_assignment_capability.dart';
import '../features/qos_profiles/qos_profiles_capability.dart';
import '../features/qos_provisioning/qos_provisioning_capability.dart';
import '../features/quality_on_demand/quality_on_demand_capability.dart';
import '../features/session_insights/session_insights_capability.dart';
import '../features/traffic_influence/traffic_influence_capability.dart';

// Device Information
import '../features/connected_network_type/connected_network_type_capability.dart';
import '../features/connected_network_type_subscriptions/connected_network_type_subscriptions_capability.dart';
import '../features/device_data_volume/device_data_volume_capability.dart';
import '../features/device_data_volume_subscriptions/device_data_volume_subscriptions_capability.dart';
import '../features/device_identifier/device_identifier_capability.dart';
import '../features/device_quality_indicator/device_quality_indicator_capability.dart';
import '../features/device_reachability_status/device_reachability_status_capability.dart';
import '../features/device_reachability_status_subscriptions/device_reachability_status_subscriptions_capability.dart';
import '../features/device_roaming_status/device_roaming_status_capability.dart';
import '../features/device_roaming_status_subscriptions/device_roaming_status_subscriptions_capability.dart';
import '../features/network_access_management/network_access_management_capability.dart';
import '../features/subscription_status/subscription_status_capability.dart';

// Computing Services
import '../features/application_endpoint_discovery/application_endpoint_discovery_capability.dart';
import '../features/application_endpoint_registration/application_endpoint_registration_capability.dart';
import '../features/edge_application_management/edge_application_management_capability.dart';
import '../features/energy_footprint_notification/energy_footprint_notification_capability.dart';
import '../features/maas_knowledge_base/maas_knowledge_base_capability.dart';
import '../features/maas_qa_assistant_manage/maas_qa_assistant_manage_capability.dart';
import '../features/maas_qa_assistant_service/maas_qa_assistant_service_capability.dart';
import '../features/optimal_edge_discovery/optimal_edge_discovery_capability.dart';
import '../features/simple_edge_discovery/simple_edge_discovery_capability.dart';
import '../features/site_to_cloud_vpn/site_to_cloud_vpn_capability.dart';

// Payments and Charging
import '../features/blockchain_public_address/blockchain_public_address_capability.dart';
import '../features/blockchain_public_address_validation/blockchain_public_address_validation_capability.dart';
import '../features/carrier_billing/carrier_billing_capability.dart';
import '../features/carrier_billing_refund/carrier_billing_refund_capability.dart';

// Service Management
import '../features/capabilities_and_runtime_restrictions/capabilities_and_runtime_restrictions_capability.dart';
import '../features/consent_info/consent_info_capability.dart';

/// CAMARA API categories as defined in https://camaraproject.org/api-overview/
enum CamaraApiCategory {
  authenticationAndFraudPrevention('Authentication and Fraud Prevention'),
  locationServices('Location Services'),
  communicationServices('Communication Services'),
  communicationQuality('Communication Quality'),
  deviceInformation('Device Information'),
  computingServices('Computing Services'),
  paymentsAndCharging('Payments and Charging'),
  serviceManagement('Service Management');

  final String displayName;
  const CamaraApiCategory(this.displayName);
}

abstract class CamaraCapability {
  String get id;
  String get title;
  String get description;
  CamaraApiCategory get category;
  bool get isSupportedByIOH => false; // Indicates if this API is supported by IOH
  Widget buildEntryPoint(BuildContext context);
}

/// All CAMARA capabilities organized by category
final Map<CamaraApiCategory, List<CamaraCapability>> capabilitiesByCategory = {
  CamaraApiCategory.authenticationAndFraudPrevention: [
    BrandRegistrationCapability(),
    CallForwardingSignalCapability(),
    CustomerInsightsCapability(),
    DeviceSwapCapability(),
    KycAgeVerificationCapability(),
    KycFillInCapability(),
    KycMatchCapability(),
    KycTenureCapability(),
    NumberRecyclingCapability(),
    NumberVerificationCapability(), // ✅ Supported by IOH
    OtpSmsCapability(),
    ScamSignalCapability(),
    SimSwapCapability(),
    SimSwapSubscriptionsCapability(),
    VerifiedCallerCapability(),
  ],
  CamaraApiCategory.locationServices: [
    DeviceLocationCapability(),
    DeviceVisitLocationCapability(),
    GeofencingSubscriptionsCapability(),
    LocationVerificationCapability(),
    MostFrequentLocationCapability(),
    PopulationDensityDataCapability(),
    RegionDeviceCountCapability(),
  ],
  CamaraApiCategory.communicationServices: [
    ClickToDialCapability(),
    MultiPointVpnCapability(),
    SmsCapability(),
    SmsDeliveryNotificationSubscriptionCapability(),
    WebRTCCallHandlingCapability(),
    WebRTCEventSubscriptionCapability(),
    WebRTCRegistrationCapability(),
  ],
  CamaraApiCategory.communicationQuality: [
    ApplicationProfilesCapability(),
    ConnectivityInsightsCapability(),
    ConnectivityInsightsSubscriptionsCapability(),
    DedicatedNetworkCapability(),
    DedicatedNetworkAccessesCapability(),
    DedicatedNetworkProfilesCapability(),
    HomeDevicesQodCapability(),
    NetworkSliceBookingCapability(),
    PredictiveConnectivityDataCapability(),
    QosBookingCapability(),
    QosBookingAndAssignmentCapability(),
    QosProfilesCapability(),
    QosProvisioningCapability(),
    QualityOnDemandCapability(),
    SessionInsightsCapability(),
    TrafficInfluenceCapability(),
  ],
  CamaraApiCategory.deviceInformation: [
    ConnectedNetworkTypeCapability(),
    ConnectedNetworkTypeSubscriptionsCapability(),
    DeviceDataVolumeCapability(),
    DeviceDataVolumeSubscriptionsCapability(),
    DeviceIdentifierCapability(),
    DeviceQualityIndicatorCapability(),
    DeviceReachabilityStatusCapability(),
    DeviceReachabilityStatusSubscriptionsCapability(),
    DeviceRoamingStatusCapability(),
    DeviceRoamingStatusSubscriptionsCapability(),
    NetworkAccessManagementCapability(),
    SubscriptionStatusCapability(),
  ],
  CamaraApiCategory.computingServices: [
    ApplicationEndpointDiscoveryCapability(),
    ApplicationEndpointRegistrationCapability(),
    EdgeApplicationManagementCapability(),
    EnergyFootprintNotificationCapability(),
    MaasKnowledgeBaseCapability(),
    MaasQaAssistantManageCapability(),
    MaasQaAssistantServiceCapability(),
    OptimalEdgeDiscoveryCapability(),
    SimpleEdgeDiscoveryCapability(),
    SiteToCloudVpnCapability(),
  ],
  CamaraApiCategory.paymentsAndCharging: [
    BlockchainPublicAddressCapability(),
    BlockchainPublicAddressValidationCapability(),
    CarrierBillingCapability(),
    CarrierBillingRefundCapability(),
  ],
  CamaraApiCategory.serviceManagement: [
    CapabilitiesAndRuntimeRestrictionsCapability(),
    ConsentInfoCapability(),
  ],
};

/// Flat list of all capabilities (for backward compatibility)
final List<CamaraCapability> capabilities = capabilitiesByCategory.values
    .expand((capabilities) => capabilities)
    .toList();
