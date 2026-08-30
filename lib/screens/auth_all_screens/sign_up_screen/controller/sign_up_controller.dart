import 'package:carely_caregiver/constant/app_api_end_point.dart';
import 'package:carely_caregiver/services/api/api_client.dart';
import 'package:carely_caregiver/services/api/api_service.dart';
import 'package:carely_caregiver/widgets/show_custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';
import '../../../../utils/error_log.dart';
import '../../../../utils/log/app_log.dart';

class SignUpController extends GetxController {
  ///////////object
  late final TextEditingController fullNameTextEditingController;
  late final TextEditingController emailTextEditingController;
  late final TextEditingController phoneTextEditingController;
  late final TextEditingController passwordTextEditingController;
  late final TextEditingController confirmPasswordTextEditingController;

  @override
  void onInit() {
    super.onInit();
    fullNameTextEditingController = TextEditingController();
    emailTextEditingController = TextEditingController();
    phoneTextEditingController = TextEditingController();
    passwordTextEditingController = TextEditingController();
    confirmPasswordTextEditingController = TextEditingController();
  }

  final formKey = GlobalKey<FormState>();

  final ApiClient _apiClient = DioApiClient();
  RxBool isLoading = false.obs;

  //////////. user types
  RxBool userTypes = true.obs;
  void changeUserType(bool value) {
    try {
      userTypes.value = value;
    } catch (e) {
      errorLog("changeUserType", e);
    }
  }

  void checkValidation() {
    if (formKey.currentState!.validate()) {
      signUpUser();
    } else {
      showCustomSnackbar(message: "Please fill all required fields correctly", isError: true);
    }
  }

  Future<void> signUpUser() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;

      Map<String, dynamic> body = {
        "name": fullNameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "password": passwordTextEditingController.text,
        "role": userTypes.value ? "CLIENT" : "CAREGIVER",
        "phone": phoneTextEditingController.text.trim(),
      };

      appLog("Request Body: $body", source: "SIGN_UP_API");
      final response = await _apiClient.post(AppApiEndPoint.signUp, body: body);
      appLog("Response Body: ${response.data}", source: "SIGN_UP_API");

      if (response.isSuccess) {
        showCustomSnackbar(message: response.message, isError: false);
        Get.toNamed(AppRoutes.instance.otpVerificationScreen, arguments: emailTextEditingController.text.trim());
      } else {
        showCustomSnackbar(message: response.message, isError: true);
      }
    } catch (e) {
      errorLog("signUpUser", e);
      showCustomSnackbar(message: "Registration failed. Please try again.", isError: true);
    } finally {
      isLoading.value = false;
    }
  }



  //////////// terms and conditions
  RxBool termsAndConditions = false.obs;
  void changeTermsAndConditions(bool value) {
    termsAndConditions.value = value;
  }

  void onAppClose() {
    try {
      // Manual disposal removed to prevent race conditions during route transitions.
      // Garbage Collector will handle the cleanup safely.
    } catch (e) {
      errorLog("onAppClose", e);
    }
  }

  @override
  void onClose() {
    onAppClose();
    super.onClose();
  }
}
