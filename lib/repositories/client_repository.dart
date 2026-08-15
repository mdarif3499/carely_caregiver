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
}
