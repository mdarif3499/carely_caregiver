import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constant/app_colors.dart';
import 'controller/error_screen_controller.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ErrorScreenController());

    return Scaffold(
      backgroundColor: AppColors.instance.screenBg,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Illustration / Offline Icon Badge
                Container(
                  width: 120.w,
                  height: 120.h,
                  decoration: BoxDecoration(
                    color: AppColors.instance.primary100.withValues(alpha: 0.4),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 90.w,
                      height: 90.h,
                      decoration: BoxDecoration(
                        color: AppColors.instance.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.wifi_off_rounded,
                        size: 48.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                32.height,
                // Title
                CommonText(
                  text: "No Internet Connection",
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  textColor: AppColors.instance.textPrimary,
                  textAlign: TextAlign.center,
                ),
                12.height,
                // Subtitle
                CommonText(
                  text:
                      "Please check your Wi-Fi or cellular network settings and try again to continue using the app.",
                  fontSize: 14.sp,
                  textColor: AppColors.instance.secondaryText,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                ),
                40.height,
                // Retry Button
                Obx(
                  () => CommonButton(
                    titleText: "Try Again",
                    isLoading: controller.isRetrying.value,
                    onTap: controller.retryConnection,
                    buttonWidth: double.infinity,
                    buttonHeight: 52.h,
                    buttonRadius: 16.r,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
