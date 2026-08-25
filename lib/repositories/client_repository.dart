import '../constant/app_api_end_point.dart';
import '../services/api/api_client.dart';
import '../services/api/api_response_model.dart';
import '../services/api/api_service.dart';

class ClientRepository {
  ClientRepository._privateConstructor();
  static final ClientRepository _instance = ClientRepository._privateConstructor();
  static ClientRepository get instance => _instance;

  final ApiClient _apiClient = DioApiClient();

  Future<ApiResponseModel> createCareRecipient({
    required String fullName,
    required String relationship,
    required String medicalConditions,
  }) async {
    Map<String, dynamic> body = {
      "fullName": fullName,
      "relationship": relationship,
      "medicalConditions": medicalConditions,
    };

    return await _apiClient.post(AppApiEndPoint.createCareRecipient, body: body);
  }

  Future<ApiResponseModel> getCareRecipients() async {
    return await _apiClient.get(AppApiEndPoint.createCareRecipient);
  }

  Future<ApiResponseModel> getCaregiverProfiles({
    String? searchTerm,
    String? specialty,
    String? skills,
    String? language,
    String? sortBy,
    String? sortOrder,
  }) async {
    final Map<String, dynamic> queryParams = {};
    if (searchTerm != null && searchTerm.isNotEmpty) queryParams['searchTerm'] = searchTerm;
    if (specialty != null && specialty.isNotEmpty) queryParams['specialty'] = specialty;
    if (skills != null && skills.isNotEmpty) queryParams['skills'] = skills;
    if (language != null && language.isNotEmpty) queryParams['language'] = language;
    if (sortBy != null && sortBy.isNotEmpty) queryParams['sortBy'] = sortBy;
    if (sortOrder != null && sortOrder.isNotEmpty) queryParams['sortOrder'] = sortOrder;

    String endpoint = AppApiEndPoint.caregiverProfiles;
    if (queryParams.isNotEmpty) {
      final queryString = queryParams.entries
          .map((e) => "${e.key}=${Uri.encodeComponent(e.value.toString())}")
          .join('&');
      endpoint = "$endpoint?$queryString";
    }

    return await _apiClient.get(endpoint);
  }

  Future<ApiResponseModel> getCaregiverAvailability({
    required String caregiverId,
    required String startDate,
    required String endDate,
  }) async {
    final endpoint = "${AppApiEndPoint.availability}/$caregiverId?startDate=$startDate&endDate=$endDate";
    return await _apiClient.get(endpoint);
  }

  Future<ApiResponseModel> createBooking({required Map<String, dynamic> data}) async {
    return await _apiClient.post(AppApiEndPoint.booking, body: data);
  }

  Future<ApiResponseModel> getClientBookings({String? date, String? status}) async {
    final Map<String, dynamic> queryParams = {};
    if (date != null) queryParams['date'] = date;
    if (status != null) queryParams['status'] = status;

    String endpoint = AppApiEndPoint.myBookings;
    if (queryParams.isNotEmpty) {
      final queryString = queryParams.entries
          .map((e) => "${e.key}=${Uri.encodeComponent(e.value.toString())}")
          .join('&');
      endpoint = "$endpoint?$queryString";
    }
    return await _apiClient.get(endpoint);
  }

  Future<ApiResponseModel> getCaregiverProfile(String id) async {
    return await _apiClient.get("${AppApiEndPoint.caregiverProfiles}/$id");
  }
}
