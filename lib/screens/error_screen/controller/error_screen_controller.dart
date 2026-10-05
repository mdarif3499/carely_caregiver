import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../services/connectivity_service/connectivity_service.dart';
import '../../../widgets/show_custom_snackbar.dart';

class ErrorScreenController extends GetxController {
  RxBool isRetrying = false.obs;

  Future<void> retryConnection() async {
    if (isRetrying.value) return;

    try {
      isRetrying.value = true;
      final connectivityService = Get.isRegistered<ConnectivityService>()
          ? Get.find<ConnectivityService>()
          : Get.put<ConnectivityService>(ConnectivityService());

      final results = await connectivityService.connectivity.checkConnectivity();

      if (!results.contains(ConnectivityResult.none) && results.isNotEmpty) {
        showCustomSnackbar(
          message: "Internet connection restored!",
          isError: false,
        );

        if (Get.previousRoute.isNotEmpty && Get.previousRoute != AppRoutes.instance.errorScreen) {
          Get.back();
        } else {
          Get.offAllNamed(AppRoutes.instance.initial);
        }
      } else {
        showCustomSnackbar(
          message: "Still no internet connection. Please check your network.",
          isError: true,
        );
      }
    } catch (e) {
      showCustomSnackbar(
        message: "Failed to verify connection. Please try again.",
        isError: true,
      );
    } finally {
      isRetrying.value = false;
    }
  }
}
