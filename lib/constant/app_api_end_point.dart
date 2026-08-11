import 'package:flutter/foundation.dart';
import 'package:core_kit/core_kit.dart';
class AppApiEndPoint {
  AppApiEndPoint._privateConstructor();
  static final AppApiEndPoint _instance = AppApiEndPoint._privateConstructor();
  static AppApiEndPoint get instance => _instance;

  //app use base
  final String domain = _getDomain();
  final String baseUrl = "${_getDomain()}/api/v1";
  final String liveServer = "https://test.com";
  final String refreshToken = "https://test.com";

  // Auth
  static const String signUp = "/auth/register";
}

String _getDomain() {
  String liveServer = "http://10.10.26.188:5050";
  String localServer = "http://10.10.26.188:5050";

  try {
    if (kDebugMode) {
      localServer;
      // return localServer;
    }
    return liveServer;
  } catch (e) {
    AppLogger.debug("Error in getting domain: $e");
    return liveServer;
  }
}
