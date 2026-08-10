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

      // bool value =await SharePrefsHelper.getBool(SharedPreferenceValue.isOnboarding)??false;
      Future.delayed(Duration(seconds: 3), () {
      //   if (value) {
      //     Get.offAllNamed(AppRoutes.instance.onBoardingScreen);
          Get.offAllNamed(AppRoutes.instance.appNavigationScreen,arguments: {"isClient": true});
        // } else {
        //   Get.offAllNamed(AppRoutes.instance.wellCome);
        // }
      }
      );
    } catch (e) {
      errorLog("onInitialDataLoadScreen", e);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed(AppRoutes.instance.errorScreen);
      });
    }
  }

  @override
  void onInit() {
    onInitialDataLoadScreen();
    super.onInit();
  }
}
