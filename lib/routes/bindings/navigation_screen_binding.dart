import 'package:carely_caregiver/screens/care_giver_screens/booking_details_screen/controller/booking_details_controller.dart';
import 'package:carely_caregiver/screens/care_giver_screens/booking_request_screen/controller/booking_request_controller.dart';
import 'package:carely_caregiver/screens/care_giver_screens/care_giver_home_screen/controller/care_giver_home_controller.dart';
import 'package:carely_caregiver/screens/care_giver_screens/earning_screen/controller/earning_screen_controller.dart';
import 'package:carely_caregiver/screens/chat_list_screen/controller/chat_list_controller.dart';
import 'package:carely_caregiver/screens/client_screen/book_caregiver_screen/controller/book_caregiver_controller.dart';
import 'package:carely_caregiver/screens/client_screen/care_giver_details_screen/controller/care_giver_details_controller.dart';
import 'package:carely_caregiver/screens/client_screen/controller/client_home_controller.dart';
import 'package:carely_caregiver/screens/client_screen/select_service_type_screen/controller/selected_service_type_controller.dart';
import 'package:carely_caregiver/screens/message_screen/controller/message_screen_controller.dart';
import 'package:carely_caregiver/screens/care_giver_screens/availability_screen/controller/availability_screen_controller.dart';
import 'package:carely_caregiver/screens/notification_screen/controller/notification_screen_controller.dart';
import 'package:carely_caregiver/screens/profile_screens/basic_info_screen/controller/basic_info_controller.dart';
import 'package:carely_caregiver/screens/client_screen/care_recipients_screen/controller/care_recipients_controller.dart';
import 'package:carely_caregiver/screens/client_screen/new_recipient_profile_screen/controller/health_profile_controller.dart';
import 'package:carely_caregiver/screens/profile_screens/personal_information_screen/controller/personal_info_controller.dart';
import 'package:carely_caregiver/screens/profile_screens/profile_screen/controller/profile_screen_controller.dart';
import 'package:carely_caregiver/screens/profile_screens/profile_setup_screen/controller/profle_setup_screen_controller.dart';
import 'package:get/get.dart';
import '../../screens/about_us_screen/controller/about_us_screen_controller.dart';
import '../../screens/app_navigation_screen/controller/app_navigation_screen_controller.dart';
import '../../screens/client_screen/find_caregiver_screen/controller/find_caregiver_controller.dart';
import '../../screens/privacy_policy_screen/controller/privacy_policy_screen_controller.dart';
import '../../screens/terms_and_conditions_screen/controller/terms_and_conditions_screen_controller.dart';

class NavigationScreenBinding extends Bindings {
  @override
  dependencies() {
    Get.lazyPut(() => AppNavigationScreenController());
    Get.lazyPut(() => TermsAndConditionsScreenController());
    Get.lazyPut(() => PrivacyPolicyScreenController());
    Get.lazyPut(() => AboutUsScreenController());
    Get.lazyPut(() => BasicInfoController());
    Get.lazyPut(() => ProfileSetupScreenController());
    Get.lazyPut(() => ClientHomeController());
    Get.lazyPut(() => FindCaregiverController());
    Get.lazyPut(() => CareGiverDetailsController());
    Get.lazyPut(() => SelectedServiceTypeController());
    Get.lazyPut(() => BookCaregiverController());
    Get.lazyPut(() => ProfileScreenController());
    Get.lazyPut(() => ChatListController());
    Get.lazyPut(() => MessageScreenController());
    Get.lazyPut(() => CareGiverHomeController());
    Get.lazyPut(() => BookingRequestController());
    Get.lazyPut(() => BookingDetailsController());
    Get.lazyPut(() => EarningScreenController());
    Get.lazyPut(() => NotificationScreenController());
    Get.lazyPut(() => AvailabilityScreenController());
    Get.lazyPut(() => PersonalInfoController());
    Get.lazyPut(() => CareRecipientsController());
    Get.lazyPut(() => HealthProfileController());
  }
}
