import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_routes.dart';
import '../../../../utils/error_log.dart';

class ChangePasswordScreenController extends GetxController {
  TextEditingController oldPasswordTextEditingController = TextEditingController();
  TextEditingController newPasswordTextEditingController = TextEditingController();
  TextEditingController confirmPasswordTextEditingController = TextEditingController();

  final RxBool isLoading = false.obs;

  void ensureControllersValid() {
    try { oldPasswordTextEditingController.text; } catch (_) { oldPasswordTextEditingController = TextEditingController(); }
    try { newPasswordTextEditingController.text; } catch (_) { newPasswordTextEditingController = TextEditingController(); }
    try { confirmPasswordTextEditingController.text; } catch (_) { confirmPasswordTextEditingController = TextEditingController(); }
  }

  @override
  void onInit() {
    super.onInit();
    ensureControllersValid();
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
