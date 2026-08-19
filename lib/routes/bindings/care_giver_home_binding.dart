import 'package:get/get.dart';
import '../../screens/care_giver_screens/availability_screen/controller/availability_screen_controller.dart';
import '../../screens/care_giver_screens/booking_details_screen/controller/booking_details_controller.dart';
import '../../screens/care_giver_screens/booking_request_screen/controller/booking_request_controller.dart';
import '../../screens/care_giver_screens/care_giver_home_screen/controller/care_giver_home_controller.dart';
import '../../screens/care_giver_screens/earning_screen/controller/earning_screen_controller.dart';

class CareGiverHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CareGiverHomeController(), fenix: true);
    Get.lazyPut(() => BookingRequestController(), fenix: true);
    Get.lazyPut(() => BookingDetailsController(), fenix: true);
    Get.lazyPut(() => EarningScreenController(), fenix: true);
    Get.lazyPut(() => AvailabilityScreenController(), fenix: true);
  }
}
