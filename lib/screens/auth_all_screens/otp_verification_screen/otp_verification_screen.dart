import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../gen/assets.gen.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/app_size.dart';
import 'controller/otp_verification_controller.dart';

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppSize.size = MediaQuery.of(context).size;

    return GetBuilder<OtpVerificationController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Obx(
              () => Skeletonizer(
                enabled: controller.isLoading.value,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      children: [
                        SizedBox(height: 20.h),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: () => Get.back(),
                            child: Container(
                              padding: EdgeInsets.all(10.r),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFFA53200).withValues(alpha: 0.08),
                              ),
                              child: Icon(
                                Icons.arrow_back_ios_new,
                                size: 16.sp,
                                color: const Color(0xFFA53200),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 40.h),
                        CommonText(
                          text: 'OTP Verification',
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.center,
                          textColor: const Color(0xFF333333),
                        ),
                        SizedBox(height: 6.h),
                        CommonText(
                          text:
                              'Please enter the 6-digit code sent to your\n${controller.type.value}.',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          textColor: const Color(0xFF6A7282),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8.h),
                        CommonText(
                          text: controller.maskedIdentity,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          textColor: const Color(0xFF333333),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 40.h),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CommonText(
                              text: 'OTP Code',
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              textColor: const Color(0xFF333333),
                            ),
                            12.height,
                            Align(
                              alignment: Alignment.center,
                              child: MaterialPinField(
                                length: 6,
                                pinController: controller.pinController,
                                onChanged: (value) {},
                                onCompleted: (value) {
                              controller.checkOtpFunction(
                                onSuccess: () =>
                                    _showSuccessDialog(context, controller),
                              );
                            },

                                theme: MaterialPinTheme(
                                  shape: MaterialPinShape.outlined,
                                  borderRadius: BorderRadius.circular(8.r),
                                  cellSize: Size(45.w, 50.h),
                                  spacing: 6.w,
                                  borderColor: const Color(0xFFF2F2F2),
                                  focusedBorderColor: const Color(0xFFA53200),
                                  filledBorderColor: const Color(0xFFF2F2F2),
                                  fillColor: const Color(0xFFF2F2F2),
                                  focusedFillColor: const Color(0xFFF2F2F2),
                                  filledFillColor: Colors.white,
                                  textStyle: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 45.h),
                        CommonButton(
                          isLoading: controller.isLoading.value,
                          buttonColor: Colors.black,
                          titleText: 'Verify',
                          onTap: () {
                            if (!controller.isLoading.value) {
                              controller.checkOtpFunction(
                                onSuccess: () => _showSuccessDialog(context, controller),
                              );
                            }
                          },
                          buttonWidth: double.infinity,
                          buttonHeight: 54.h,
                          buttonRadius: 14.r,
                        ),
                        SizedBox(height: 12.h),
                        CommonText(
                          text: "Don't receive the code?",
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          textColor: const Color(0xFF333333),
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFf0ded7),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Row(
                                children: [
                                  _timerBox(controller.minutes, 'minutes'),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 8.w),
                                    height: 30.h,
                                    width: 2.w,
                                    color: Colors.white,
                                  ),
                                  _timerBox(controller.seconds, 'seconds'),
                                ],
                              ),
                            ),
                            SizedBox(width: 16.w),
                            controller.isResending.value
                                ? SizedBox(
                                    height: 20.h,
                                    width: 20.w,
                                    child: const CircularProgressIndicator(
                                        strokeWidth: 2, color: Color(0xFFA53200)),
                                  )
                                : GestureDetector(
                                    onTap: controller.canResend.value
                                        ? () => controller.reSendOtp()
                                        : null,
                                    child: CommonText(
                                      text: 'Resend',
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      textColor: controller.canResend.value
                                          ? const Color(0xFFA53200)
                                          : Colors.grey,
                                    ),
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }


  Widget _timerBox(String value, String label) {
    return Column(
      children: [
        CommonText(
          text: value,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          textColor: const Color(0xFF003757),
        ),
        CommonText(
          text: label, 
          fontSize: 10, 
          textColor: const Color(0xFF003757)
        ),
      ],
    );
  }

  void _showSuccessDialog(BuildContext context, OtpVerificationController controller) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF4CAF50),
                  ),
                  child: CommonImage(
                    src: Assets.icons.verify,
                    height: 40.h,
                    width: 40.w,
                  ),
                ),
                SizedBox(height: 20.h),
                const CommonText(
                  text: 'Verification complete!',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.center,
                  textColor: Color(0xFF333333),
                ),
                SizedBox(height: 12.h),
                const CommonText(
                  text: 'Everything is set! Let\'s get started',
                  fontSize: 16,
                  textColor: Color(0xFF6A7282),
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 10.h),
              ],
            ),
          ),
        ),
      );

      Future.delayed(const Duration(seconds: 2), () {
        if (Get.isOverlaysOpen) {
          Get.back();
        }
        final user = controller.userData;
        Get.offAllNamed(
          AppRoutes.instance.basicInfoScreen,
          arguments: {
            "isClient": user['role'] == "CLIENT",
            "email": user['email'],
            "name": user['name'] ?? "",
            "phone": user['phone'] ?? "",
          },
        );
      });
    });
  }
}
