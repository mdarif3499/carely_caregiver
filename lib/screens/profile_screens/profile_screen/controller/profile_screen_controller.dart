import 'package:carely_caregiver/routes/app_routes.dart';
import 'package:carely_caregiver/services/share_pref_helper/share_pref_helper.dart';
import 'package:get/get.dart';
import '../../../../models/user_model.dart';
import '../../../../repositories/user_repository.dart';
import '../../../../utils/error_log.dart';

// ── Controller ───────────────────────────────────────────
class ProfileScreenController extends GetxController {
  final Rxn<UserModel> userModel = Rxn<UserModel>();
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    fetchProfile();
    super.onInit();
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      update();

      final response = await UserRepository.instance.getMyProfile();

      if (response.isSuccess) {
        final data = response.data['data'];
        if (data != null) {
          userModel.value = UserModel.fromJson(data);
        }
      }
    } catch (e) {
      errorLog("ProfileScreen fetchProfile", e);
    } finally {
      isLoading.value = false;
      update();
    }
  }

  void logout() async {
    await SharePrefsHelper.clearData();
    Get.offAllNamed(AppRoutes.instance.loginScreen);
  }
}
