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
}

String _getDomain() {
  String liveServer = "https://test.com";
  String localServer = "https://test.com";

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
