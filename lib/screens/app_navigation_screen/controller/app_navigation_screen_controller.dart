import 'package:get/get.dart';

import '../../../app_all_enum/app_login_status.dart';
import '../../../utils/error_log.dart';

class AppNavigationScreenController extends GetxController {
  int selectedIndex = 0;
  bool isClient = false;
  @override
  void onInit() {
    // Ensure a default value is set explicitly. The previous code used '=='
    // which is a comparison and does nothing. Use assignment '=' to set the
    // default app user type if you need one here.
    isClient = Get.arguments['isClient'] ?? false;
    selectedAppUserType =
    isClient ? AppUserType.client : AppUserType.caregiver;
    super.onInit();
  }

  /// Set the global selected app user type and rebuild the UI that depends on it.
  ///
  /// Call this from anywhere (for example after login or when switching mode):
  void setAppUserType(AppUserType type) {
    selectedAppUserType = type;
    // trigger rebuild of GetBuilder widgets that use this controller
    update();
  }

  void changeIndex(int index) {
    try {
      selectedIndex = index;
      update();
    } catch (e) {
      errorLog("changeIndex", e);
    }
  }
}
