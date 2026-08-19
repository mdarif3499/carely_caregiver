import 'package:get/get.dart';
import '../../../app_all_enum/app_login_status.dart';
import '../../../models/user_model.dart';
import '../../../repositories/user_repository.dart';
import '../../../utils/error_log.dart';

class AppNavigationScreenController extends GetxController {
  int selectedIndex = 0;
  bool isClient = false;
  Rxn<UserModel> userModel = Rxn<UserModel>();
  RxBool isProfileLoading = false.obs;

  @override
  void onInit() {
    isClient = Get.arguments?['isClient'] ?? false;
    selectedIndex = Get.arguments?['selectedIndex'] ?? 0;
    selectedAppUserType =
    isClient ? AppUserType.client : AppUserType.caregiver;
    fetchProfile();
    super.onInit();
  }

  Future<void> fetchProfile() async {
    try {
      isProfileLoading.value = true;
      update();

      final response = await UserRepository.instance.getMyProfile();

      if (response.isSuccess) {
        final data = response.data['data'];
        if (data != null) {
          userModel.value = UserModel.fromJson(data);
        }
      }
    } catch (e) {
      errorLog("fetchProfile", e);
    } finally {
      isProfileLoading.value = false;
      update();
    }
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
