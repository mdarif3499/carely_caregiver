import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constant/app_assert_image.dart';
import '../../../../constant/app_colors.dart';
import '../../../../utils/app_size.dart';
import '../controller/forgot_screen_controller.dart';

class ForgotEmailInputScreen extends StatelessWidget {
  const ForgotEmailInputScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: ForgotScreenController(),
      builder: (controller) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SingleChildScrollView(
                child: Form(
                  key: controller.formKey1,
                  child: Column(
                    children: [
                      CommonImage(src: AppAssertImage.instance.forgotEmailInput, width: AppSize.size.width * 0.6),
                      10.height,
                      CommonText(text: "Forgot password", fontSize: 25, fontWeight: FontWeight.w500),
                      10.height,
                      CommonText(text: "Enter your email to reset your \npassword.", fontSize: 16, fontWeight: FontWeight.w400, textAlign: TextAlign.center, height: 1.5),
                      10.height,
                      CommonTextField(
                        labelText: "Email",
                        hintText: "Enter your mail",
                        validationType: ValidationType.validateEmail,
                        borderColor: AppColors.instance.boxBg,
                      ),
                     10.height,
                    ],
                  ),
                ),
              ),

              Column(
                children: [
                  CommonButton(
                    titleText: "Get OTP",
                    onTap: () {
                      controller.checkEmailFunction();
                    },
                  ),
                  50.height,
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
