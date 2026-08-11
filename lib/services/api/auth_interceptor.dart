import 'package:dio/dio.dart';
import '../share_pref_helper/share_pref_helper.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await SharePrefsHelper.getString(SharedPreferenceValue.token);
    
    if (token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    
    super.onRequest(options, handler);
  }
}
