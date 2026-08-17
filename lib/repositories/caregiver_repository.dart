import 'dart:io';
import 'package:dio/dio.dart';
import '../constant/app_api_end_point.dart';
import '../services/api/api_client.dart';
import '../services/api/api_response_model.dart';
import '../services/api/api_service.dart';

class CaregiverRepository {
  CaregiverRepository._privateConstructor();
  static final CaregiverRepository _instance = CaregiverRepository._privateConstructor();
  static CaregiverRepository get instance => _instance;

  final ApiClient _apiClient = DioApiClient();

  Future<ApiResponseModel> uploadDocument({
    required String documentType,
    required File file,
  }) async {
    Map<String, dynamic> body = {
      "documentType": documentType,
      "nursingCert": await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      ),
    };

    return await _apiClient.multipart(AppApiEndPoint.uploadDocument, body: body, method: 'POST');
  }

  Future<ApiResponseModel> updateProfile({
    required Map<String, dynamic> profileData,
  }) async {
    return await _apiClient.patch(AppApiEndPoint.updateCaregiverProfile, body: profileData);
  }
}
