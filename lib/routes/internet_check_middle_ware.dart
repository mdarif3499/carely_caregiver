import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:core_kit/utils/app_log.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/error_screen/error_screen.dart';
import '../services/connectivity_service/connectivity_service.dart';
import 'app_routes.dart';

bool _isNavigating = false;

class InternetCheckMiddleWare extends GetMiddleware {
  ConnectivityService connectivityService = Get.isRegistered<ConnectivityService>()
      ? Get.find<ConnectivityService>()
      : Get.put<ConnectivityService>(ConnectivityService());

  List<ConnectivityResult> result = <ConnectivityResult>[];
  InternetCheckMiddleWare() {
    _onInitialData();
  }
  _onInitialData() {
    try {
      // Listen to connectivity changes
      ///////////////////// production time un-comment
      connectivityService.connectivity.onConnectivityChanged.listen((data) async {
        result = <ConnectivityResult>[];
        result.addAll(data);
        if (data.contains(ConnectivityResult.none) && !_isNavigating && Get.currentRoute != AppRoutes.instance.errorScreen) {
          _isNavigating = true;

          if (AppRoutes.instance.errorScreen.isNotEmpty && Get.currentRoute != AppRoutes.instance.errorScreen) {
            await Get.offAllNamed(AppRoutes.instance.errorScreen)?.then((value) {
              _isNavigating = false;
            });
          }
        }
      });
    } catch (e) {
      AppLogger.error("Error== $e");
    }
  }

  @override
  RouteSettings? redirect(String? route) {
    if (connectivityService.connectionStatus.contains(ConnectivityResult.none)) {
      return RouteSettings(name: AppRoutes.instance.errorScreen);
    }
    // return super.redirect(route);
    return null;
  }

  @override
  GetPage? onPageCalled(GetPage? page) {
    if (connectivityService.connectionStatus.contains(ConnectivityResult.none)) {
      return GetPage(name: AppRoutes.instance.errorScreen, page: () => const ErrorScreen());
    }
    return super.onPageCalled(page);
  }

  @override
  GetPageBuilder? onPageBuildStart(GetPageBuilder? page) {
    if (connectivityService.connectionStatus.contains(ConnectivityResult.none)) {
      return () => const ErrorScreen();
    }
    return super.onPageBuildStart(page);
  }

  @override
  Widget onPageBuilt(Widget page) {
    if (connectivityService.connectionStatus.contains(ConnectivityResult.none)) {
      return const ErrorScreen();
    } else {
      return super.onPageBuilt(page);
    }
    // return super.onPageBuilt(page);
  }
}
