import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../constant/app_assert_image.dart';
import '../../../../constant/app_colors.dart';
import '../../../../utils/app_size.dart';
import '../controller/forgot_screen_controller.dart';

class ForgotEmailInputScreen extends StatelessWidget {
  const ForgotEmailInputScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ForgotScreenController>();
    return Obx(
      () => Skeletonizer(
        enabled: controller.isLoading.value,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SingleChildScrollView(
                child: Form(
                  key: controller.formKey1,
                  child: Column(
                    children: [
                      CommonImage(
                          src: AppAssertImage.instance.forgotEmailInput,
                          width: AppSize.size.width * 0.6),
                      10.height,
                      CommonText(
                          text: "Forgot password",
                          fontSize: 25.sp,
                          fontWeight: FontWeight.w600,
                          textColor: const Color(0xFF333333)),
                      10.height,
                      CommonText(
                          text: "Enter your email to reset your \npassword.",
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          textAlign: TextAlign.center,
                          height: 1.5,
                          textColor: const Color(0xFF6A7282)),
                      20.height,
                      CommonTextField(
                        controller: controller.emailController,
                        labelText: "Email",
                        hintText: "Enter your mail",
                        validationType: ValidationType.validateEmail,
                        borderColor: AppColors.instance.boxBg,
                        validation: (value) {
                          if (value == null || value.trim().isEmpty) return "Email is required";
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value)) return "Enter a valid email";
                          return null;
                        },
                      ),
                      10.height,
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  CommonButton(
                    isLoading: controller.isLoading.value,
                    titleText: "Get OTP",
                    buttonHeight: 54.h,
                    buttonWidth: double.infinity,
                    buttonRadius: 14.r,
                    onTap: () {
                      controller.checkEmailFunction();
                    },
                  ),
                  50.height,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
