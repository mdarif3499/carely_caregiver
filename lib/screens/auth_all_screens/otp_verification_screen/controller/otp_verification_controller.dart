import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carely_caregiver/widgets/show_custom_snackbar.dart';
import '../../../../routes/app_routes.dart';
import '../../../../services/share_pref_helper/share_pref_helper.dart';
import '../../../../utils/error_log.dart';
import '../../../../utils/app_utils.dart';
import '../../../../services/api/api_client.dart';
import '../../../../services/api/api_service.dart';
import '../../../../constant/app_api_end_point.dart';

import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../utils/log/app_log.dart';

class OtpVerificationController extends GetxController {
  late final TextEditingController otpController;
  late final PinInputController pinController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    otpController = TextEditingController();
    pinController = PinInputController(textController: otpController);
    _loadInitialData();
  }

  final ApiClient _apiClient = DioApiClient();
  RxBool isLoading = false.obs;
  RxBool isResending = false.obs;

  RxString identity = "".obs;
  RxString type = "email".obs;
  Map<String, dynamic> userData = {};

  RxInt timerSeconds = 180.obs;
  Timer? _timer;
  RxBool canResend = false.obs;


    ///   PHASE_CLIENT_ON_CONTROLS_CHANGED
   ///   PHASE_CLIENT_ON_CONTROLS_CHANGED
  ///   requestedVisibleTypes to 503 (was 511)



  void _loadInitialData() {
    try {
      final argData = Get.arguments;
      if (argData is String) {
        identity.value = argData;
      } else if (argData is Map) {
        identity.value = (argData['identity'] ?? argData['email'] ?? '').toString();
        type.value = (argData['type'] ?? 'email').toString();
      }

      if (identity.value.isEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.offAllNamed(AppRoutes.instance.errorScreen);
        });
      } else {
        startTimer();
      }
    } catch (e) {
      errorLog("loadInitialData", e);
    }
  }
  /// 🌐║ POST ║ Status: 200 OK  ║📡
  void startTimer() {
    _timer?.cancel();
    canResend.value = false;
    timerSeconds.value = 180;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerSeconds.value > 0) {
        timerSeconds.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  Future<void> reSendOtp() async {
    if (isResending.value || !canResend.value) return;

    try {
      isResending.value = true;
      update();

      Map<String, dynamic> body = {
        type.value == 'email' ? 'email' : 'phone': identity.value,
        'isResetPassword': false,
      };
      
      appLog("Request Body: $body", source: "SEND_OTP_REG_API");
      final response = await _apiClient.post(AppApiEndPoint.sendOtp, body: body);
      appLog("Response Body: ${response.data}", source: "SEND_OTP_REG_API");

      if (response.isSuccess) {
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

  Future<void> checkOtpFunction({required Function onSuccess}) async {
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
        "email": identity.value,
        "otp": int.tryParse(otp) ?? otp,
      };

      appLog("Request Body: $body", source: "VERIFY_EMAIL_API");
      final response = await _apiClient.post(AppApiEndPoint.verifyEmail, body: body);
      appLog("Response Body: ${response.data}", source: "VERIFY_EMAIL_API");
      if (response.isSuccess) {
        final payload = response.data['data'] ?? {};
        final accessToken = payload['accessToken'] ?? "";
        final refreshToken = payload['refreshToken'] ?? "";
        final user = payload['user'] ?? {};
        userData = user;

        if (accessToken.toString().isNotEmpty) {
          await SharePrefsHelper.setString(SharedPreferenceValue.token, accessToken);
          await SharePrefsHelper.setString(SharedPreferenceValue.refreshToken, refreshToken);
          await SharePrefsHelper.setString(SharedPreferenceValue.userId, user['id'] ?? "");
          await SharePrefsHelper.setString(SharedPreferenceValue.email, user['email'] ?? "");
          await SharePrefsHelper.setString(SharedPreferenceValue.role, user['role'] ?? "");
          await SharePrefsHelper.setString(SharedPreferenceValue.phone, user['phone'] ?? "");
        }

        showCustomSnackbar(message: response.message, isError: false);
        onSuccess();
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

  String get minutes => (timerSeconds.value ~/ 60).toString().padLeft(2, '0');
  String get seconds => (timerSeconds.value % 60).toString().padLeft(2, '0');

  String get maskedIdentity {
    final value = identity.value;
    if (type.value == 'email' && value.contains('@')) {
      return AppUtils.maskEmail(value);
    }
    return value;
  }

  bool _isDisposed = false;

  @override
  void onClose() {
    if (_isDisposed) return;
    try {
      _timer?.cancel();
      // Manual disposal removed for lifecycle stability.
      _isDisposed = true;
    } catch (e) {
      errorLog("onClose", e);
    }
    super.onClose();
  }
}
