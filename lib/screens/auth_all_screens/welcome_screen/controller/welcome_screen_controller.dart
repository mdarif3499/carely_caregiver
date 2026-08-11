import 'package:carely_caregiver/constant/app_api_end_point.dart';
import 'package:carely_caregiver/services/api/api_client.dart';
import 'package:carely_caregiver/services/api/api_service.dart';
import 'package:carely_caregiver/widgets/show_custom_snackbar.dart';
import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';

class WelcomeScreenController extends GetxController {
  RxInt selectedIndex = RxInt(-1);
  final ApiClient _apiClient = DioApiClient();
  RxBool isLoading = false.obs;

  Future<void> registerUser() async {
    if (selectedIndex.value == -1) {
      showCustomSnackbar(message: "Please select a role", isError: true);
      return;
    }

    final signupData = Get.arguments;
    if (signupData == null) {
      showCustomSnackbar(message: "User data missing. Please try signing up again.", isError: true);
      return;
    }

    try {
      isLoading.value = true;
      update();

      final role = selectedIndex.value == 1 ? "CLIENT" : "CAREGIVER";
      
      Map<String, dynamic> body = {
        "name": signupData['name'],
        "email": signupData['email'],
        "password": signupData['password'],
        "role": role,
        "phone": signupData['phone'],
      };

      final response = await _apiClient.post(AppApiEndPoint.signUp, body: body);

      if (response.isSuccess) {
        showCustomSnackbar(message: response.message, isError: false);
        Get.toNamed(AppRoutes.instance.otpVerificationScreen, arguments: signupData['email']);
      } else {
        showCustomSnackbar(message: response.message, isError: true);
      }
    } catch (e) {
      showCustomSnackbar(message: "Registration failed. Please try again.", isError: true);
    } finally {
      isLoading.value = false;
      update();
    }
  }
}
