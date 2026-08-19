import 'package:flutter/foundation.dart';
import 'package:core_kit/core_kit.dart';
class AppApiEndPoint {
  AppApiEndPoint._privateConstructor();
  static final AppApiEndPoint _instance = AppApiEndPoint._privateConstructor();
  static AppApiEndPoint get instance => _instance;

  final String domain = _getDomain();
  final String baseUrl = "${_getDomain()}/api/v1";
  final String liveServer = "https://test.com";
  final String refreshToken = "https://test.com";

  static const String signUp = "/auth/register";
  static const String sendOtp = "/auth/send-otp";
  static const String verifyEmail = "/auth/verify-email";
  static const String login = "/auth/login";
  static const String resetPassword = "/auth/reset-password";

  static const String updateProfile = "/user/my-profile";
  static const String myProfile = "/user/my-profile";

  static const String createCareRecipient = "/care-recipient";

  static const String uploadDocument = "/document/upload";
  static const String updateCaregiverProfile = "/caregiver-profiles/me";
  static const String availability = "/availability";
  static const String getMyAvailability = "/availability/me";
}

String _getDomain() {
  String liveServer = "http://10.10.26.188:5050";
  String localServer = "http://10.10.26.188:5050";

  try {
    if (kDebugMode) {
      localServer;
    }
    return liveServer;
  } catch (e) {
    AppLogger.debug("Error in getting domain: $e");
    return liveServer;
  }
}
