import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:carely_caregiver/services/api/api_client.dart';
import 'package:carely_caregiver/services/api/api_service.dart';
import 'package:carely_caregiver/constant/app_api_end_point.dart';
import 'package:carely_caregiver/widgets/show_custom_snackbar.dart';
import '../../../../routes/app_routes.dart';
import '../../../../utils/error_log.dart';
import '../../../../utils/log/app_log.dart';

class ForgotScreenController extends GetxController {
  final ApiClient _apiClient = DioApiClient();
  RxBool isLoading = false.obs;
  RxBool isResending = false.obs;
  
  PageController pageController = PageController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController confirmPasswordTextEditingController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  late final PinInputController pinController;
  GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  GlobalKey<FormState> formKey3 = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    pinController = PinInputController(textController: otpController);
  }

  void checkEmailFunction() {
    try {
      if (formKey1.currentState!.validate()) {
        pageController.nextPage(duration: 180.milliseconds, curve: Curves.easeInOut);
        startTimer();
      }
    } catch (e) {
      errorLog("checkOtpFunction", e);
    }
  }

  Future<void> checkOtpFunction() async {
    final otp = otpController.text.trim();
    if (otp.isEmpty || otp.length < 6) {
      showCustomSnackbar(message: "Please enter a valid 6-digit OTP", isError: true);
      return;
    }

    if (isLoading.value) return;

    try {
      isLoading.value = true;
      update();

      Map<String, dynamic> body = {
        "email": emailController.text.trim(),
        "otp": int.tryParse(otp) ?? otp,
      };

      appLog("Request Body: $body", source: "VERIFY_EMAIL_API");
      final response = await _apiClient.post(AppApiEndPoint.verifyEmail, body: body);
      appLog("Response Body: ${response.data}", source: "VERIFY_EMAIL_API");

      if (response.isSuccess) {
        pageController.nextPage(duration: 180.milliseconds, curve: Curves.easeInOut);
      } else {
        showCustomSnackbar(message: response.message, isError: true);
      }
    } catch (e) {
      errorLog("checkOtpFunction", e);
      showCustomSnackbar(message: "Verification failed. Please try again.", isError: true);
    } finally {
      isLoading.value = false;
      update();
    }
  }

  void checkCreateFunction() {
    try {
      if (formKey3.currentState!.validate()) {
        showCustomSnackbar(message: "Login with your credentials", title: '');
        Get.offAllNamed(AppRoutes.instance.loginScreen);
      }
    } catch (e) {
      errorLog("checkOtpFunction", e);
    }
  }

  RxInt secondsRemaining = 60.obs;
  Timer? _timer;

  Future<void> reSendOtp() async {
    if (isResending.value) return;

    try {
      isResending.value = true;
      update();

      Map<String, dynamic> body = {
        'email': emailController.text.trim(),
      };
      
      appLog("Request Body: $body", source: "SEND_OTP_API");
      final response = await _apiClient.post(AppApiEndPoint.sendOtp, body: body);
      appLog("Response Body: ${response.data}", source: "SEND_OTP_API");

      if (response.isSuccess) {
        secondsRemaining.value = 60;
        startTimer();
        showCustomSnackbar(message: response.message, isError: false);
      } else {
        showCustomSnackbar(message: response.message, isError: true);
      }
    } catch (e) {
      errorLog("reSendOtp", e);
      showCustomSnackbar(message: "Failed to resend OTP", isError: true);
    } finally {
      isResending.value = false;
      update();
    }
  }

  void startTimer() {
    try {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (secondsRemaining.value > 0) {
          secondsRemaining.value = secondsRemaining.value - 1;
        } else {
          _timer?.cancel();
        }
      });
    } catch (e) {
      errorLog("startTimer", e);
    }
  }

  void onAppClose() {
    try {
      _timer?.cancel();
      emailController.dispose();
      otpController.dispose();
      passwordTextEditingController.dispose();
      confirmPasswordTextEditingController.dispose();
      pageController.dispose();
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
