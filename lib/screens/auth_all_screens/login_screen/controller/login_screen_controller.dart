import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';
import '../../../../utils/error_log.dart';

class LoginScreenController extends GetxController {
  ////////// object
  TextEditingController fullNameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  RxBool isSignInPage = true.obs;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  void checkValidation() {
    try {
      if (formKey.currentState!.validate()) {
        Get.offAndToNamed(AppRoutes.instance.appNavigationScreen);
      }
    } catch (e) {
      errorLog("checkValidation", e);
    }
  }

  ///////////. app. close
  void appOnClose() {
    try {
      fullNameTextEditingController.dispose();
      emailTextEditingController.dispose();
      phoneTextEditingController.dispose();
      passwordTextEditingController.dispose();
    } catch (e) {
      errorLog("appOnClose", e);
    }
  }

  @override
  void onClose() {
    appOnClose();
    super.onClose();
  }
}
