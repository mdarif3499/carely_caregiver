import 'package:get/get.dart';
import '../../screens/client_screen/book_caregiver_screen/controller/book_caregiver_controller.dart';
import '../../screens/client_screen/care_giver_details_screen/controller/care_giver_details_controller.dart';
import '../../screens/client_screen/care_recipients_screen/controller/care_recipients_controller.dart';
import '../../screens/client_screen/controller/client_home_controller.dart';
import '../../screens/client_screen/find_caregiver_screen/controller/find_caregiver_controller.dart';
import '../../screens/client_screen/new_recipient_profile_screen/controller/health_profile_controller.dart';
import '../../screens/client_screen/select_service_type_screen/controller/selected_service_type_controller.dart';

class ClientHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ClientHomeController(), fenix: true);
    Get.lazyPut(() => FindCaregiverController(), fenix: true);
    Get.lazyPut(() => CareGiverDetailsController(), fenix: true);
    Get.lazyPut(() => SelectedServiceTypeController(), fenix: true);
    Get.lazyPut(() => BookCaregiverController(), fenix: true);
    Get.lazyPut(() => CareRecipientsController(), fenix: true);
    Get.lazyPut(() => HealthProfileController(), fenix: true);
  }
}
