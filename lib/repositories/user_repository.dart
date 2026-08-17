import 'dart:io';
import 'package:dio/dio.dart';
import '../constant/app_api_end_point.dart';
import '../services/api/api_client.dart';
import '../services/api/api_response_model.dart';
import '../services/api/api_service.dart';

class UserRepository {
  UserRepository._privateConstructor();
  static final UserRepository _instance = UserRepository._privateConstructor();
  static UserRepository get instance => _instance;

  final ApiClient _apiClient = DioApiClient();

  Future<ApiResponseModel> updateProfile({
    required String name,
    required String phone,
    required bool intakeCompleted,
    File? profileImage,
  }) async {
    Map<String, dynamic> body = {
      "name": name,
      "phone": phone,
      "intakeCompleted": intakeCompleted.toString(),
    };

    if (profileImage != null) {
      body["profileImage"] = await MultipartFile.fromFile(
        profileImage.path,
        filename: profileImage.path.split('/').last,
      );
    }

    return await _apiClient.multipart(AppApiEndPoint.updateProfile, body: body);
  }

  Future<ApiResponseModel> getMyProfile() async {
    return await _apiClient.get(AppApiEndPoint.myProfile);
  }
}
