import 'package:carely_caregiver/constant/app_api_end_point.dart';
import 'package:carely_caregiver/services/api/api_client.dart';
import 'package:carely_caregiver/services/api/api_response_model.dart';
import 'package:carely_caregiver/services/api/api_service.dart';

class AuthRepository {
  AuthRepository._privateConstructor();
  static final AuthRepository _instance = AuthRepository._privateConstructor();
  static AuthRepository get instance => _instance;

  final ApiClient _apiClient = DioApiClient();

  Future<ApiResponseModel> login(String email, String password) async {
    Map<String, dynamic> body = {
      "email": email,
      "password": password,
    };
    return await _apiClient.post(AppApiEndPoint.login, body: body);
  }

  Future<ApiResponseModel> resetPassword({
    required String newPassword,
    required String confirmPassword,
    required String resetToken,
  }) async {
    Map<String, dynamic> body = {
      "newPassword": newPassword,
      "confirmPassword": confirmPassword,
    };
    return await _apiClient.post(
      AppApiEndPoint.resetPassword,
      body: body,
      headers: {"Authorization": "Bearer $resetToken"},
    );
  }
}
