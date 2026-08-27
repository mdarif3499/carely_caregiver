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
    // Dynamic field name based on document type as per backend documentation
    String fieldName = "";
    switch (documentType) {
      case "GOVERNMENT_ID": fieldName = "governmentId"; break;
      case "NURSING_CERT": fieldName = "nursingCert"; break;
      case "CRIMINAL_RECORD": fieldName = "criminalRecord"; break;
      case "INSURANCE": fieldName = "insurance"; break;
      default: fieldName = "document";
    }

    Map<String, dynamic> body = {
      "documentType": documentType,
      fieldName: await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      ),
    };

    return await _apiClient.multipart(AppApiEndPoint.uploadDocument, body: body, method: 'POST');
  }

  Future<ApiResponseModel> getMyDocuments() async {
    return await _apiClient.get(AppApiEndPoint.getMyDocuments);
  }

  Future<ApiResponseModel> updateProfile({
    required Map<String, dynamic> profileData,
  }) async {
    return await _apiClient.patch(AppApiEndPoint.updateCaregiverProfile, body: profileData);
  }

  Future<ApiResponseModel> addAvailability({
    required Map<String, dynamic> data,
  }) async {
    return await _apiClient.post(AppApiEndPoint.availability, body: data);
  }

  Future<ApiResponseModel> getAvailability({
    required String startDate,
    required String endDate,
  }) async {
    return await _apiClient.get(
      "${AppApiEndPoint.getMyAvailability}?startDate=$startDate&endDate=$endDate",
    );
  }

  Future<ApiResponseModel> updateShift({
    required String availabilityId,
    required String shiftId,
    required Map<String, dynamic> data,
  }) async {
    return await _apiClient.patch(
      "${AppApiEndPoint.availability}/$availabilityId/shift/$shiftId",
      body: data,
    );
  }

  Future<ApiResponseModel> deleteShift({
    required String availabilityId,
    required String shiftId,
  }) async {
    return await _apiClient.delete(
      "${AppApiEndPoint.availability}/$availabilityId/shift/$shiftId",
    );
  }

  Future<ApiResponseModel> getCategories() async {
    return await _apiClient.get(AppApiEndPoint.categories);
  }

  Future<ApiResponseModel> getCaregiverBookings({String? date}) async {
    String endpoint = AppApiEndPoint.caregiverBooking;
    if (date != null) {
      endpoint = "$endpoint?date=$date";
    }
    return await _apiClient.get(endpoint);
  }

  Future<ApiResponseModel> getBookingDetails(String id) async {
    return await _apiClient.get("${AppApiEndPoint.booking}/$id");
  }

  Future<ApiResponseModel> acceptBooking(String id) async {
    return await _apiClient.patch("${AppApiEndPoint.booking}/$id/accept");
  }

  Future<ApiResponseModel> declineBooking(String id) async {
    return await _apiClient.patch("${AppApiEndPoint.booking}/$id/decline");
  }

  Future<ApiResponseModel> getEarningsSummary() async {
    return await _apiClient.get(AppApiEndPoint.earningsSummary);
  }
}
