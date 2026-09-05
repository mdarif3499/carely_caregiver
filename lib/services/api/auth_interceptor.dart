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
    if (_shouldLogout(response.data, response.statusCode)) {
      _handleLogout();
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (_shouldLogout(err.response?.data, err.response?.statusCode)) {
      _handleLogout();
    }
    super.onError(err, handler);
  }

  bool _shouldLogout(dynamic data, int? statusCode) {
    // 1. Check for standard 401 Unauthorized status code
    if (statusCode == 401) return true;

    // 2. Check for specific backend message "Session Expired"
    if (data is Map) {
      final message = (data['message'] ?? '').toString().toLowerCase();
      if (message.contains('session expired') || message.contains('unauthorized')) {
        return true;
      }
    }
    return false;
  }

  void _handleLogout() async {
    if (_isLoggingOut) return;
    _isLoggingOut = true;

    try {
      // Professional feedback before wiping data
      showCustomSnackbar(
        message: "Your session has expired. Please login again to continue.", 
        isError: true,
      );

      // Give the user a moment to see the message
      await Future.delayed(const Duration(milliseconds: 1500));

      // Securely clear all session data
      await SharePrefsHelper.clearData();
      
      // Wipe navigation stack and go to login
      get_x.Get.offAllNamed(AppRoutes.instance.loginScreen);
    } catch (e) {
      // Fallback navigation if something fails
      get_x.Get.offAllNamed(AppRoutes.instance.loginScreen);
    } finally {
      // Reset flag after a sufficient delay
      Future.delayed(const Duration(seconds: 5), () {
        _isLoggingOut = false;
      });
    }
  }
}
