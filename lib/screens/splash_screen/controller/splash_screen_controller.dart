import 'package:carely_caregiver/services/share_pref_helper/share_pref_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../../../utils/error_log.dart';

class SplashScreenController extends GetxController {
  ////////////  object
  RxDouble animation = 0.0.obs;
  RxDouble animation2 = 0.0.obs;

  Future<void> onInitialDataLoadScreen() async {
    try {
      Future.delayed(Durations.medium1, () {
        animation.value = 1.0;
        animation2.value = 1.0;
      });

      // Professional login check "from main"
      String token = await SharePrefsHelper.getString(SharedPreferenceValue.token);
      String role = await SharePrefsHelper.getString(SharedPreferenceValue.role);

      Future.delayed(const Duration(seconds: 3), () {
        if (token.isNotEmpty) {
          // Auto-login: Navigate to dashboard
          Get.offAllNamed(AppRoutes.instance.appNavigationScreen, arguments: {"isClient": role == "CLIENT"});
        } else {
          // No token: Navigate to onboarding or login
          Get.offAllNamed(AppRoutes.instance.loginScreen);
        }
      });
    } catch (e) {
      errorLog("onInitialDataLoadScreen", e);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed(AppRoutes.instance.loginScreen);
      });
    }
  }

  @override
  void onInit() {
    onInitialDataLoadScreen();
    super.onInit();
  }
}
