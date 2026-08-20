import 'package:get/get.dart';
import '../../screens/about_us_screen/controller/about_us_screen_controller.dart';
import '../../screens/privacy_policy_screen/controller/privacy_policy_screen_controller.dart';
import '../../screens/profile_screens/basic_info_screen/controller/basic_info_controller.dart';
import '../../screens/profile_screens/edit_professional_profile_screen/controller/edit_professional_profile_controller.dart';
import '../../screens/profile_screens/notification_settings_screen/controller/notification_settings_controller.dart';
import '../../screens/profile_screens/personal_information_screen/controller/personal_info_controller.dart';
import '../../screens/profile_screens/profile_screen/controller/profile_screen_controller.dart';
import '../../screens/profile_screens/profile_setup_screen/controller/profle_setup_screen_controller.dart';
import '../../screens/terms_and_conditions_screen/controller/terms_and_conditions_screen_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProfileScreenController(), fenix: true);
    Get.lazyPut(() => BasicInfoController(), fenix: true);
    Get.lazyPut(() => ProfileSetupScreenController(), fenix: true);
    Get.lazyPut(() => PersonalInfoController(), fenix: true);
    Get.lazyPut(() => NotificationSettingsController(), fenix: true);
    Get.lazyPut(() => TermsAndConditionsScreenController(), fenix: true);
    Get.lazyPut(() => PrivacyPolicyScreenController(), fenix: true);
    Get.lazyPut(() => AboutUsScreenController(), fenix: true);
    Get.lazyPut(() => EditProfessionalProfileController(), fenix: true);
  }
}
