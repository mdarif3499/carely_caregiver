import 'package:flutter/foundation.dart';
class AppApiEndPoint {
  AppApiEndPoint._privateConstructor();
  static final AppApiEndPoint _instance = AppApiEndPoint._privateConstructor();
  static AppApiEndPoint get instance => _instance;

  final String domain = _getDomain();
  final String baseUrl = "${_getDomain()}/api/v1";
  final String socketUrl = _getDomain();
  final String refreshToken = "${_getDomain()}/api/v1/auth/refresh-token";
  static const String signUp = "/auth/register";
  static const String sendOtp = "/auth/send-otp";
  static const String verifyEmail = "/auth/verify-email";
  static const String login = "/auth/login";
  static const String resetPassword = "/auth/reset-password";
  static const String updateProfile = "/user/my-profile";
  static const String myProfile = "/user/my-profile";
  static const String createCareRecipient = "/care-recipient";
  static const String uploadDocument = "/document/upload";
  static const String getMyDocuments = "/document/me";
  static const String updateCaregiverProfile = "/caregiver-profiles/me";
  static const String availability = "/availability";
  static const String getMyAvailability = "/availability/me";
  static const String caregiverProfiles = "/caregiver-profiles";
  static const String categories = "/categories";
  static const String booking = "/booking";
  static const String myBookings = "/booking/my";
  static const String caregiverBooking = "/booking/caregiver";
  static const String earningsSummary = "/earnings/me/summary";
  static const String earnings = "/earnings/me";
  static const String notifications = "/notification/my";
  static const String conversation = "/conversation";
  static const String message = "/message";
  static const String cms = "/cms";

  static String imageUrl(String? path) {
    if (path == null || path.isEmpty) return "";
    if (path.startsWith("http")) return path;
    String cleanPath = path.startsWith("/") ? path.substring(1) : path;
    return "${AppApiEndPoint.instance.baseUrl}/uploads/$cleanPath";
  }
}

String _getDomain() {
  const String liveServer = "https://rahad5000.naimulhassan.me";
  const String localServer = "https://rahad5000.naimulhassan.me";

  // const String liveServer =  "http://10.10.26.188:5000";
  // const String localServer = "http://10.10.26.188:5000";

  return kDebugMode ? localServer : liveServer;
}
