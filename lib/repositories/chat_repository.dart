import '../constant/app_api_end_point.dart';
import '../services/api/api_client.dart';
import '../services/api/api_response_model.dart';
import '../services/api/api_service.dart';

class ChatRepository {
  ChatRepository._privateConstructor();
  static final ChatRepository _instance = ChatRepository._privateConstructor();
  static ChatRepository get instance => _instance;

  final ApiClient _apiClient = DioApiClient();

  Future<ApiResponseModel> getConversations() async {
    return await _apiClient.get(AppApiEndPoint.conversation);
  }

  Future<ApiResponseModel> getOrCreateConversation(String receiverId) async {
    Map<String, dynamic> body = {
      "receiverId": receiverId,
    };
    return await _apiClient.post(AppApiEndPoint.conversation, body: body);
  }

  Future<ApiResponseModel> getConversationDetails(String id) async {
    return await _apiClient.get("${AppApiEndPoint.conversation}/$id");
  }

  Future<ApiResponseModel> getMessages(String conversationId, int page) async {
    return await _apiClient.get("${AppApiEndPoint.message}/$conversationId?page=$page&limit=20");
  }

  Future<ApiResponseModel> sendMessage({
    required String conversationId,
    required String content,
    required String contentType,
    dynamic attachment,
  }) async {
    Map<String, dynamic> body = {
      "conversationId": conversationId,
      "content": content,
      "contentType": contentType,
    };

    if (attachment != null) {
      body["attachment"] = attachment;
      return await _apiClient.multipart(AppApiEndPoint.message, body: body, method: 'POST');
    }

    return await _apiClient.post(AppApiEndPoint.message, body: body);
  }
}
