import 'package:carely_caregiver/utils/app_utils.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../constant/app_assert_image.dart';
import '../../../../constant/app_colors.dart';
import '../../../../utils/app_size.dart';
import '../controller/forgot_screen_controller.dart';

class ForgotOtpInputScreen extends StatelessWidget {
  const ForgotOtpInputScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ForgotScreenController>();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20.0)),
      child: Column(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20.0)),
            child: Form(
              key: controller.formKey2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonImage(src: AppAssertImage.instance.otpVerification, width: AppSize.size.width * 0.8),

                  Column(
                    children: [
                      const CommonText(text: "Verify your account", fontSize: 25, fontWeight: FontWeight.w500),
                      5.height,
                      CommonText(text: "We've Sent a Code to ${AppUtils.maskEmail(controller.emailController.text)}"),
                      30.height,
                      Align(
                        alignment: Alignment.center,
                        child: MaterialPinField(
                          length: 6,
                          pinController: controller.pinController,
                          onChanged: (value) {},
                          onCompleted: (value) {
                            controller.checkOtpFunction();
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
                      10.height,
                      Obx(
                        () => RichText(
                          text: TextSpan(
                            text: "Resend code in ${AppUtils.formatSecondFunction(controller.secondsRemaining.value)} ",
                            style: TextStyle(color: AppColors.instance.dark400, fontSize: 14),
                            children: [
                              TextSpan(
                                text: "Resend",
                                style: TextStyle(color: controller.secondsRemaining.value > 0 ? AppColors.instance.dark400 : AppColors.instance.primary500),
                                recognizer:
                                    TapGestureRecognizer()
                                      ..onTap = () {
                                        controller.reSendOtp();
                                      },
                              ),
                            ],
                          ),
                        ),
                      ),
                      50.height,
                    ],
                  ),
                ],
              ),
            ),
          ),

          Column(
            children: [
              CommonButton(
                titleText: "Verify",
                onTap: () {
                  controller.checkOtpFunction();
                },
              ),
              50.height,
            ],
          ),
        ],
      ),
    );
  }
}
