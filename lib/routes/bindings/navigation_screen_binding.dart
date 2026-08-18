import 'package:get/get.dart';
import '../../screens/app_navigation_screen/controller/app_navigation_screen_controller.dart';
import '../../screens/notification_screen/controller/notification_screen_controller.dart';

class NavigationScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AppNavigationScreenController(), fenix: true);
    Get.lazyPut(() => NotificationScreenController(), fenix: true);
  }
}
