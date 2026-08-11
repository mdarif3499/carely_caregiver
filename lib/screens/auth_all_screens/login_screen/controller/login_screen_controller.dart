import 'package:carely_caregiver/constant/app_api_end_point.dart';
import 'package:carely_caregiver/services/api/api_client.dart';
import 'package:carely_caregiver/services/api/api_service.dart';
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

  final ApiClient _apiClient = DioApiClient();
  RxBool isLoading = false.obs;

  Future<void> loginUser() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;
      update();

      Map<String, dynamic> body = {
        "email": emailTextEditingController.text.trim(),
        "password": passwordTextEditingController.text,
      };

      appLog("Request Body: $body", source: "LOGIN_API");
      final response = await _apiClient.post(AppApiEndPoint.login, body: body);
      appLog("Response Body: ${response.data}", source: "LOGIN_API");

      if (response.isSuccess) {
        final data = response.data;
        final accessToken = data['accessToken'] ?? "";
        final user = data['user'] ?? {};

        if (accessToken.toString().isNotEmpty) {
          await SharePrefsHelper.setString(SharedPreferenceValue.token, accessToken);
          await SharePrefsHelper.setString(SharedPreferenceValue.userId, user['id'] ?? "");
          await SharePrefsHelper.setString(SharedPreferenceValue.email, user['email'] ?? "");
          await SharePrefsHelper.setString(SharedPreferenceValue.role, user['role'] ?? "");
        }

        showCustomSnackbar(message: response.message, isError: false);
        // Navigate based on role or logic
        Get.offAndToNamed(AppRoutes.instance.appNavigationScreen, arguments: {"isClient": user['role'] == "CLIENT"});
      } else {
        showCustomSnackbar(message: response.message, isError: true);
      }
    } catch (e) {
      errorLog("loginUser", e);
      showCustomSnackbar(message: "Login failed. Please try again.", isError: true);
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
