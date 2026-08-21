import 'package:dio/dio.dart';
import 'package:get/get.dart' as get_x;
import '../../routes/app_routes.dart';
import '../../widgets/show_custom_snackbar.dart';
import '../share_pref_helper/share_pref_helper.dart';

class AuthInterceptor extends Interceptor {
  static bool _isLoggingOut = false;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await SharePrefsHelper.getString(SharedPreferenceValue.token);
    
    if (token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.data is Map && response.data['message'] == "Session Expired") {
      _handleLogout();
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.data is Map && err.response?.data['message'] == "Session Expired") {
      _handleLogout();
    }
    super.onError(err, handler);
  }

  void _handleLogout() async {
    if (_isLoggingOut) return;
    _isLoggingOut = true;

    try {
      await SharePrefsHelper.clearData();
      showCustomSnackbar(message: "Session Expired. Please login again.", isError: true);
      get_x.Get.offAllNamed(AppRoutes.instance.loginScreen);
    } finally {
      // Reset flag after a delay to allow navigation to complete
      Future.delayed(const Duration(seconds: 2), () {
        _isLoggingOut = false;
      });
    }
  }
}
