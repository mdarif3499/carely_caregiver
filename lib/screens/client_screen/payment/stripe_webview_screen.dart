import 'package:carely_caregiver/routes/app_routes.dart';
import 'package:carely_caregiver/widgets/show_custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../constant/app_colors.dart';

class StripeWebViewScreen extends StatefulWidget {
  const StripeWebViewScreen({super.key});

  @override
  State<StripeWebViewScreen> createState() => _StripeWebViewScreenState();
}

class _StripeWebViewScreenState extends State<StripeWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  late final String checkoutUrl;

  @override
  void initState() {
    super.initState();
    
    // Get URL from arguments
    checkoutUrl = Get.arguments as String;

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (url) {
            setState(() {
              _isLoading = false;
            });

            // Detect success/cancel from Stripe redirect URL
            if (url.contains("success")) {
              Get.offAllNamed(AppRoutes.instance.appNavigationScreen);
              showCustomSnackbar(message: "Payment successful! Your booking is confirmed.", isError: false);
            }
            else if (url.contains("cancel") || url.contains("failure")) {
              Get.back();
              showCustomSnackbar(message: "Payment was cancelled or failed.", isError: true);
            }
          },
          onWebResourceError: (error) {
            debugPrint('WebView Error: ${error.description}');
          },
        ),
      )
      ..loadRequest(Uri.parse(checkoutUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Payment",
          style: TextStyle(
            color: AppColors.instance.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.instance.textPrimary, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(color: AppColors.instance.primary),
            ),
        ],
      ),
    );
  }
}
