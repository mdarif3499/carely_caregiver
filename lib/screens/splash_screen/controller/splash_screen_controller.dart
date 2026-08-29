import 'dart:async';

import 'package:carely_caregiver/services/share_pref_helper/share_pref_helper.dart';
import 'package:carely_caregiver/services/socket/socket_service.dart';

import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../../../utils/error_log.dart';

class SplashScreenController extends GetxController {
  ////////////  object
  RxDouble animation = 0.0.obs;
  RxDouble animation2 = 0.0.obs;

  Future<void> onInitialDataLoadScreen() async {
    try {
      // Start animations immediately
      Future.delayed(const Duration(milliseconds: 100), () {
        animation.value = 1.0;
        animation2.value = 1.0;
      });

      // Parallel tasks: Check auth + Socket (Socket is already inited in main, but ensuring here)
      final results = await Future.wait([
        SharePrefsHelper.getString(SharedPreferenceValue.token),
        Future.delayed(const Duration(seconds: 2)), // Minimum splash duration
      ]);

      final String token = results[0] as String;

      if (token.isNotEmpty) {
        unawaited(SocketService.connect());
        Get.offAllNamed(AppRoutes.instance.appNavigationScreen);
      } else {
        Get.offAllNamed(AppRoutes.instance.loginScreen);
      }
    } catch (e) {
      errorLog("onInitialDataLoadScreen", e);
      Get.offAllNamed(AppRoutes.instance.loginScreen);
    }
  }

  @override
  void onInit() {
    onInitialDataLoadScreen();
    super.onInit();
  }
}
