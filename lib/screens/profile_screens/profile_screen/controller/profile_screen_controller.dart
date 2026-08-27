import 'package:carely_caregiver/routes/app_routes.dart';
import 'package:carely_caregiver/services/share_pref_helper/share_pref_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../models/user_model.dart';
import '../../../../repositories/user_repository.dart';
import '../../../../utils/error_log.dart';

class ProfileScreenController extends GetxController {
  final Rxn<UserModel> userModel = Rxn<UserModel>();
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _setPlaceholder();
    fetchProfile();
  }

  void _setPlaceholder() {
    userModel.value = UserModel(
      id: 'placeholder',
      name: 'User Name',
      role: 'Role',
      email: 'user@example.com',
      phone: '(123) 456-7890',
      intakeCompleted: true,
      createdAt: DateTime.now(),
    );
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;

      final response = await UserRepository.instance.getMyProfile();

      if (response.isSuccess) {
        final data = response.data['data'];
        if (data != null) {
          userModel.value = UserModel.fromJson(data);
        }
      } else {
        debugPrint("Profile fetch failed: ${response.message}");
      }
    } catch (e) {
      errorLog("ProfileScreen fetchProfile", e);
    } finally {
      isLoading.value = false;
    }
  }

  void logout() async {
    await SharePrefsHelper.clearData();
    Get.offAllNamed(AppRoutes.instance.loginScreen);
  }
}
