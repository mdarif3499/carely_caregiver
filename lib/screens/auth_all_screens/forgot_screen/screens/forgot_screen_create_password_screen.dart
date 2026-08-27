import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../constant/app_assert_image.dart';
import '../../../../constant/app_colors.dart';
import '../../../../utils/app_size.dart';
import '../controller/forgot_screen_controller.dart';

class ForgotScreenCreatePasswordScreen extends StatelessWidget {
  const ForgotScreenCreatePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ForgotScreenController>();
    return Obx(
      () => Skeletonizer(
        enabled: controller.isLoading.value,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SingleChildScrollView(
                child: Form(
                  key: controller.formKey3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonImage(
                          src: AppAssertImage.instance.forgotCreatePassword,
                          width: AppSize.size.width * 0.6),
                      Column(
                        children: [
                          10.height,
                          CommonText(
                              text: "Create new password",
                              fontSize: 25.sp,
                              fontWeight: FontWeight.w600,
                              textColor: const Color(0xFF333333)),
                          5.height,
                          const CommonText(
                              text: "Password must have 8 characters",
                              textColor: Color(0xFF6A7282)),
                          50.height,
                        ],
                      ),
                      CommonTextField(
                        controller: controller.passwordTextEditingController,
                        borderColor: AppColors.instance.boxBg,
                        labelText: "New password",
                        hintText: "Enter your new password",
                        validationType: ValidationType.validatePassword,
                        validation: (value) {
                          if (value == null || value.trim().isEmpty) return "Password is required";
                          if (value.length < 8) return "Password must be at least 8 characters";
                          return null;
                        },
                      ),
                      20.height,
                      CommonTextField(
                        controller: controller.confirmPasswordTextEditingController,
                        borderColor: AppColors.instance.boxBg,
                        labelText: "Confirm new Password",
                        hintText: "Enter new confirm password",
                        validationType: ValidationType.validateConfirmPassword,
                        textInputAction: TextInputAction.done,
                        originalPassword: () => controller.passwordTextEditingController.text,
                        validation: (value) {
                          if (value == null || value.trim().isEmpty) return "Confirm password is required";
                          if (value != controller.passwordTextEditingController.text) return "Passwords do not match";
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 40.h,),
              Column(
                children: [
                  CommonButton(
                    isLoading: controller.isLoading.value,
                    titleText: "Update Password",
                    buttonHeight: 54.h,
                    buttonWidth: double.infinity,
                    buttonRadius: 14.r,
                    onTap: controller.isLoading.value 
                      ? null 
                      : () {
                      controller.checkCreateFunction();
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
