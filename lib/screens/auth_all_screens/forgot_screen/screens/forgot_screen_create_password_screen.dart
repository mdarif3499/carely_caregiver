import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constant/app_assert_image.dart';
import '../../../../constant/app_colors.dart';
import '../../../../utils/app_size.dart';
import '../controller/forgot_screen_controller.dart';

class ForgotScreenCreatePasswordScreen extends StatelessWidget {
  const ForgotScreenCreatePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ForgotScreenController>();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20.0)),
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
                      const CommonText(
                          text: "Create new password",
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          textColor: Color(0xFF333333)),
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
              Obx(
                () => CommonButton(
                  isLoading: controller.isLoading.value,
                  titleText: "Update Password",
                  onTap: controller.isLoading.value 
                    ? null 
                    : () {
                    controller.checkCreateFunction();
                  },
                ),
              ),
              50.height,
            ],
          ),
        ],
      ),
    );
  }
}
