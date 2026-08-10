import 'package:core_kit/core_kit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constant/app_assert_image.dart';
import '../../../constant/app_colors.dart';
import '../../../utils/app_size.dart';
import 'controller/otp_related_function.dart';
import 'controller/otp_verification_controller.dart';

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppSize.size = MediaQuery.of(context).size;

    return GetBuilder(
      init: OtpVerificationController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(),
          body: SizedBox(
            width: AppSize.size.width,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20.0)),
              child: Form(
                key: controller.formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CommonImage(src: AppAssertImage.instance.otpVerification, width: AppSize.size.width * 0.8),

                    Column(
                      children: [
                        CommonText(text: "Verify your account", fontSize: 25, fontWeight: FontWeight.w500),
                        5.height,
                        CommonText(text: "We've Sent a Code to ${OtpRelatedFunction().maskEmail(controller.email.value)}"),
                        30.height,
                        CommonTextField(
                          borderColor: AppColors.instance.primary300,
                          hintText: "_ _ _ _ _ _",
                          textAlign: TextAlign.center,
                          validationType: ValidationType.notRequired,
                        ),
                        10.height,
                        Obx(
                          () => RichText(
                            text: TextSpan(
                              text: "Resend code in ${OtpRelatedFunction().formatSecondFunction(controller.secondsRemaining.value)} ",
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

                    CommonButton(titleText: "Verify", onTap: controller.checkOtpFunction),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
