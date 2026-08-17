import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'api_client.dart';
import 'api_response_handler.dart';
import 'api_response_model.dart';
import 'auth_interceptor.dart';
import '../../constant/app_api_end_point.dart';

class DioApiClient implements ApiClient {
  final Dio _dio;

  DioApiClient({Dio? dio}) : _dio = dio ?? _createDio();

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppApiEndPoint.instance.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
      ),
    );

    dio.interceptors.addAll([
      AuthInterceptor(),
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    ]);

    return dio;
  }

  @override
  Future<ApiResponseModel> get(
    String url, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) {
    return _request(url, method: 'GET', query: query, headers: headers);
  }

  @override
  Future<ApiResponseModel> post(
    String url, {
    dynamic body,
    Map<String, String>? headers,
  }) {
    return _request(url, method: 'POST', body: body, headers: headers);
  }

  @override
  Future<ApiResponseModel> put(
    String url, {
    dynamic body,
    Map<String, String>? headers,
  }) {
    return _request(url, method: 'PUT', body: body, headers: headers);
  }

  @override
  Future<ApiResponseModel> patch(
    String url, {
    dynamic body,
    Map<String, String>? headers,
  }) {
    return _request(url, method: 'PATCH', body: body, headers: headers);
  }

  @override
  Future<ApiResponseModel> delete(
    String url, {
    dynamic body,
    Map<String, String>? headers,
  }) {
    return _request(url, method: 'DELETE', body: body, headers: headers);
  }

  @override
  Future<ApiResponseModel> multipart(
    String url, {
    required Map<String, dynamic> body,
    String method = 'POST',
    Map<String, String>? headers,
  }) async {
    final formData = FormData.fromMap(body);
    return _request(url, method: method, body: formData, headers: headers);
  }

  Future<ApiResponseModel> _request(
    String url, {
    required String method,
    dynamic body,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.request(
        url,
        data: body,
        queryParameters: query,
        options: Options(method: method, headers: headers),
      );
      return ApiResponseHandler.handleSuccess(response);
    } catch (e) {
      return ApiResponseHandler.handleError(e);
    }
  }
}
