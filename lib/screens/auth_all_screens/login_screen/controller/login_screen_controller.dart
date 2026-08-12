import 'package:carely_caregiver/constant/app_api_end_point.dart';
import 'package:carely_caregiver/repositories/auth_repository.dart';
import 'package:carely_caregiver/services/share_pref_helper/share_pref_helper.dart';
import 'package:carely_caregiver/widgets/show_custom_snackbar.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';
import '../../../../utils/error_log.dart';
import '../../../../utils/log/app_log.dart';

class LoginScreenController extends GetxController {
  ////////// object
  final emailTextEditingController = TextEditingController();
  final fullNameTextEditingController = TextEditingController();
  final phoneTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();

  RxBool isSignInPage = true.obs;
  final formKey = GlobalKey<FormState>();

  RxBool isLoading = false.obs;

  Future<void> loginUser() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;
      update();

      appLog("Attempting login for: ${emailTextEditingController.text.trim()}", source: "LOGIN_API");
      
      final response = await AuthRepository.instance.login(
        emailTextEditingController.text.trim(),
        passwordTextEditingController.text,
      );
      
      appLog("Response Status: ${response.statusCode}, Body: ${response.data}", source: "LOGIN_API");

      if (response.isSuccess) {
        final payload = response.data['data'] ?? {};
        final accessToken = payload['accessToken'] ?? "";
        final refreshToken = payload['refreshToken'] ?? "";
        final user = payload['user'] ?? {};

        if (accessToken.toString().isNotEmpty) {
          await SharePrefsHelper.setString(SharedPreferenceValue.token, accessToken);
          await SharePrefsHelper.setString(SharedPreferenceValue.refreshToken, refreshToken);
          await SharePrefsHelper.setString(SharedPreferenceValue.userId, user['id'] ?? "");
          await SharePrefsHelper.setString(SharedPreferenceValue.email, user['email'] ?? "");
          await SharePrefsHelper.setString(SharedPreferenceValue.role, user['role'] ?? "");
          
          showCustomSnackbar(message: response.message, isError: false);
          
          // Professional navigation after success based on actual role
          Get.offAllNamed(AppRoutes.instance.appNavigationScreen, arguments: {"isClient": user['role'] == "CLIENT"});
        } else {
          showCustomSnackbar(message: "Authentication token missing from response.", isError: true);
        }
      } else {
        showCustomSnackbar(message: response.message, isError: true);
      }
    } catch (e) {
      errorLog("loginUser", e);
      showCustomSnackbar(message: "Login failed. Please check your connection.", isError: true);
    } finally {
      isLoading.value = false;
      update();
    }
  }
  void checkValidation() {
    try {
      if (formKey.currentState!.validate()) {
        Get.offAndToNamed(AppRoutes.instance.appNavigationScreen);
      }
    } catch (e) {
      errorLog("checkValidation", e);
    }
  }

  bool _isDisposed = false;

  ///////////. app. close
  void appOnClose() {
    if (_isDisposed) return;
    try {
      fullNameTextEditingController.dispose();
      emailTextEditingController.dispose();
      phoneTextEditingController.dispose();
      passwordTextEditingController.dispose();
      _isDisposed = true;
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
