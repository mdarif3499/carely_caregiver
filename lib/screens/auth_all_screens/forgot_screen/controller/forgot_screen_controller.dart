import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:carely_caregiver/services/api/api_client.dart';
import 'package:carely_caregiver/services/api/api_service.dart';
import 'package:carely_caregiver/constant/app_api_end_point.dart';
import 'package:carely_caregiver/widgets/show_custom_snackbar.dart';
import '../../../../repositories/auth_repository.dart';
import '../../../../routes/app_routes.dart';
import '../../../../utils/error_log.dart';
import '../../../../utils/log/app_log.dart';

class ForgotScreenController extends GetxController {
  final ApiClient _apiClient = DioApiClient();
  RxBool isLoading = false.obs;
  RxBool isResending = false.obs;
  late final PageController pageController;
  late final TextEditingController emailController;
  late final TextEditingController passwordTextEditingController;
  late final TextEditingController confirmPasswordTextEditingController;
  late final TextEditingController otpController;
  late final PinInputController pinController;
  GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  GlobalKey<FormState> formKey3 = GlobalKey<FormState>();

  String resetToken = "";

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
    emailController = TextEditingController();
    passwordTextEditingController = TextEditingController();
    confirmPasswordTextEditingController = TextEditingController();
    otpController = TextEditingController();
    pinController = PinInputController(textController: otpController);
  }

  Future<void> checkEmailFunction() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      showCustomSnackbar(message: "Please enter your email", isError: true);
      return;
    }

    if (isLoading.value) return;

    try {
      isLoading.value = true;
      update();

      Map<String, dynamic> body = {
        "email": email,
        "isResetPassword": true,
      };

      appLog("Request Body: $body", source: "SEND_OTP_FORGOT_API");
      final response = await _apiClient.post(AppApiEndPoint.sendOtp, body: body);
      appLog("Response Body: ${response.data}", source: "SEND_OTP_FORGOT_API");

      if (response.isSuccess) {
        if (!isClosed) {
          showCustomSnackbar(message: response.message, isError: false);
          
          // Unfocus to prevent keyboard glitches during page transition
          FocusManager.instance.primaryFocus?.unfocus();
          
          pageController.nextPage(duration: 180.milliseconds, curve: Curves.easeInOut);
          startTimer();
        }
      } else {
        showCustomSnackbar(message: response.message, isError: true);
      }
    } catch (e) {
      errorLog("checkEmailFunction", e);
      showCustomSnackbar(message: "Failed to send OTP. Please try again.", isError: true);
    } finally {
      if (!isClosed) {
        isLoading.value = false;
        update();
      }
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
        final payload = response.data['data'] ?? {};
        resetToken = payload['resetToken'] ?? "";
        
        // Unfocus to prevent keyboard glitches during page transition
        FocusManager.instance.primaryFocus?.unfocus();
        
        pageController.nextPage(duration: 180.milliseconds, curve: Curves.easeInOut);
      } else {
        showCustomSnackbar(message: response.message, isError: true);
      }
    } catch (e) {
      errorLog("checkOtpFunction", e);
      showCustomSnackbar(message: "Verification failed. Please try again.", isError: true);
    } finally {
      if (!isClosed) {
        isLoading.value = false;
        update();
      }
    }
  }

  Future<void> checkCreateFunction() async {
    try {
      if (formKey3.currentState!.validate()) {
        if (isLoading.value) return;

        isLoading.value = true;
        update();

        final response = await AuthRepository.instance.resetPassword(
          newPassword: passwordTextEditingController.text.trim(),
          confirmPassword: confirmPasswordTextEditingController.text.trim(),
          resetToken: resetToken,
        );

        if (response.isSuccess) {
          showCustomSnackbar(message: response.message, title: '', isError: false);
          
          // 1. Force keyboard to close and clear focus
          FocusManager.instance.primaryFocus?.unfocus();
          
          // 2. Wait for the keyboard animation to finish and for the framework 
          // to unlock the widget tree before wiping the stack.
          Future.delayed(const Duration(milliseconds: 500), () {
             Get.offAllNamed(AppRoutes.instance.loginScreen);
          });
        } else {
          showCustomSnackbar(message: response.message, isError: true);
        }
      }
    } catch (e) {
      errorLog("checkCreateFunction", e);
      showCustomSnackbar(message: "Failed to reset password", isError: true);
    } finally {
      if (!isClosed) {
        isLoading.value = false;
        update();
      }
    }
  }

  RxInt secondsRemaining = 240.obs;
  Timer? _timer;

  Future<void> reSendOtp() async {
    if (isResending.value) return;

    try {
      isResending.value = true;
      update();

      Map<String, dynamic> body = {
        'email': emailController.text.trim(),
        'isResetPassword': true,
      };
      
      appLog("Request Body: $body", source: "RESEND_OTP_FORGOT_API");
      final response = await _apiClient.post(AppApiEndPoint.sendOtp, body: body);
      appLog("Response Body: ${response.data}", source: "RESEND_OTP_FORGOT_API");

      if (response.isSuccess) {
        secondsRemaining.value = 240;
        startTimer();
        showCustomSnackbar(message: response.message, isError: false);
      } else {
        showCustomSnackbar(message: response.message, isError: true);
      }
    } catch (e) {
      errorLog("reSendOtp", e);
      showCustomSnackbar(message: "Failed to resend OTP", isError: true);
    } finally {
      if (!isClosed) {
        isResending.value = false;
        update();
      }
    }
  }

  void startTimer() {
    try {
      _timer?.cancel();
      secondsRemaining.value = 240;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (secondsRemaining.value > 0) {
          secondsRemaining.value = secondsRemaining.value - 1;
        } else {
          timer.cancel();
        }
      });
    } catch (e) {
      errorLog("startTimer", e);
    }
  }

  void onAppClose() {
    try {
      _timer?.cancel();
      // Manual disposal of controllers removed to prevent "used after disposed" crash 
      // during stack-wipe transitions (Get.offAllNamed).
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
