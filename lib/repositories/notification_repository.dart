import '../constant/app_api_end_point.dart';
import '../services/api/api_client.dart';
import '../services/api/api_response_model.dart';
import '../services/api/api_service.dart';

class NotificationRepository {
  NotificationRepository._privateConstructor();
  static final NotificationRepository _instance = NotificationRepository._privateConstructor();
  static NotificationRepository get instance => _instance;

  final ApiClient _apiClient = DioApiClient();

  Future<ApiResponseModel> getMyNotifications({int page = 1}) async {
    return await _apiClient.get("${AppApiEndPoint.notifications}?page=$page&limit=10");
  }

  Future<ApiResponseModel> markAsRead(String id) async {
    return await _apiClient.patch("${AppApiEndPoint.notifications}/$id/read");
  }
}
