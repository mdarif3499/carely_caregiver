import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/connectivity_service/connectivity_service.dart';
import 'app_routes.dart';

class InternetCheckMiddleWare extends GetMiddleware {
  late final ConnectivityService _connectivityService;

  InternetCheckMiddleWare() {
    _connectivityService = Get.isRegistered<ConnectivityService>()
        ? Get.find<ConnectivityService>()
        : Get.put<ConnectivityService>(ConnectivityService(), permanent: true);
  }

  @override
  RouteSettings? redirect(String? route) {
    // Only redirect to error screen if navigating to a screen while completely offline
    // and if not already heading to the error screen.
    if (route != AppRoutes.instance.errorScreen &&
        _connectivityService.connectionStatus.contains(ConnectivityResult.none)) {
      return RouteSettings(name: AppRoutes.instance.errorScreen);
    }
    return null;
  }

  @override
  Widget onPageBuilt(Widget page) {
    return page;
  }
}
