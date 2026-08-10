import 'package:get/get.dart';
import '../../screens/error_screen/controller/error_screen_controller.dart';
import '../../screens/not_found_screen/controller/not_found_screen_controller.dart';
import '../../screens/splash_screen/controller/splash_screen_controller.dart';

class SplashScreenBinding extends Bindings {
  @override
  dependencies() {
    Get.lazyPut(() => SplashScreenController());
    Get.lazyPut(() => ErrorScreenController());
    Get.lazyPut(() => NotFoundScreenController());
  }
}
