import 'api_response_model.dart';

abstract class ApiClient {
  Future<ApiResponseModel> get(
    String url, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  });

  Future<ApiResponseModel> post(
    String url, {
    dynamic body,
    Map<String, String>? headers,
  });

  Future<ApiResponseModel> put(
    String url, {
    dynamic body,
    Map<String, String>? headers,
  });

  Future<ApiResponseModel> patch(
    String url, {
    dynamic body,
    Map<String, String>? headers,
  });

  Future<ApiResponseModel> delete(
    String url, {
    dynamic body,
    Map<String, String>? headers,
  });

  Future<ApiResponseModel> multipart(
    String url, {
    required Map<String, dynamic> body,
    String method = 'POST',
    Map<String, String>? headers,
  });
}
