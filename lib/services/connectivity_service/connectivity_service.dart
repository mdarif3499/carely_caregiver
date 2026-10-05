import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';
import '../../widgets/show_custom_snackbar.dart';

class ConnectivityService extends GetxController {
  RxList<ConnectivityResult> connectionStatus = <ConnectivityResult>[].obs;
  RxBool isConnected = true.obs;
  final Connectivity connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> connectivitySubscription;
  bool _hasInitialCheckRun = false;

  Future<void> initConnectivity() async {
    try {
      List<ConnectivityResult> result = await connectivity.checkConnectivity();
      _updateConnectionStatus(result);
      _hasInitialCheckRun = true;

      connectivitySubscription = connectivity.onConnectivityChanged.listen((event) {
        _updateConnectionStatus(event);
      });
    } on PlatformException catch (e) {
      AppLogger.error("Connectivity init error: $e");
    }
  }

  Future<bool> checkConnection() async {
    try {
      final results = await connectivity.checkConnectivity();
      final connected = !results.contains(ConnectivityResult.none) && results.isNotEmpty;
      isConnected.value = connected;
      return connected;
    } catch (e) {
      return false;
    }
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) {
    try {
      connectionStatus.value = result;
      connectionStatus.refresh();

      final offline = result.contains(ConnectivityResult.none) || result.isEmpty;
      final wasConnected = isConnected.value;
      isConnected.value = !offline;

      if (_hasInitialCheckRun) {
        if (offline && wasConnected) {
          showCustomSnackbar(
            title: "Network Offline",
            message: "No internet connection. Please check your network.",
            isError: true,
            duration: const Duration(seconds: 4),
          );
        } else if (!offline && !wasConnected) {
          showCustomSnackbar(
            title: "Network Restored",
            message: "Internet connection restored!",
            isError: false,
            duration: const Duration(seconds: 3),
          );

          // If currently on ErrorScreen, navigate back automatically
          if (Get.currentRoute == AppRoutes.instance.errorScreen) {
            if (Get.previousRoute.isNotEmpty && Get.previousRoute != AppRoutes.instance.errorScreen) {
              Get.back();
            } else {
              Get.offAllNamed(AppRoutes.instance.initial);
            }
          }
        }
      }
    } catch (e) {
      AppLogger.error("Connectivity update error: $e");
    }
  }

  @override
  void onInit() {
    super.onInit();
    initConnectivity();
  }

  @override
  void onClose() {
    connectivitySubscription.cancel();
    super.onClose();
  }
}
