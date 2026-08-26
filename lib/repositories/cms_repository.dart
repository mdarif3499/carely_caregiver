import '../constant/app_api_end_point.dart';
import '../services/api/api_client.dart';
import '../services/api/api_response_model.dart';
import '../services/api/api_service.dart';

class CMSRepository {
  CMSRepository._privateConstructor();
  static final CMSRepository _instance = CMSRepository._privateConstructor();
  static CMSRepository get instance => _instance;

  final ApiClient _apiClient = DioApiClient();

  Future<ApiResponseModel> getPage(String slug) async {
    return await _apiClient.get("${AppApiEndPoint.cms}/$slug");
  }
}
