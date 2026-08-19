import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_routes.dart';
import '../../../../utils/error_log.dart';

class ChangePasswordScreenController extends GetxController {
  ///////////////////  object
  late final TextEditingController oldPasswordTextEditingController;
  late final TextEditingController newPasswordTextEditingController;
  late final TextEditingController confirmPasswordTextEditingController;

  @override
  void onInit() {
    super.onInit();
    oldPasswordTextEditingController = TextEditingController();
    newPasswordTextEditingController = TextEditingController();
    confirmPasswordTextEditingController = TextEditingController();
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void checkData() {
    try {
      if (formKey.currentState!.validate()) {
        Get.offAllNamed(AppRoutes.instance.loginScreen);
      }
    } catch (e) {
      errorLog('checkData', e);
    }
  }

  void onAppClose() {
    try {
      // Manual disposal removed for lifecycle stability during navigation.
    } catch (e) {
      errorLog('onAppClose', e);
    }
  }

  @override
  void onClose() {
    onAppClose();
    super.onClose();
  }
}
