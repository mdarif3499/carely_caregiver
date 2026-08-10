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
    return GetBuilder(
      init: ForgotScreenController(),
      builder: (controller) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20.0)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SingleChildScrollView(
                child: Form(
                  key: controller.formKey3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonImage(src: AppAssertImage.instance.forgotCreatePassword, width: AppSize.size.width * 0.6),

                      Column(
                        children: [
                          10.height,
                          CommonText(text: "Create new password", fontSize: 25, fontWeight: FontWeight.w500),
                          5.height,
                          CommonText(text: "Password must have 8 characters", textColor: AppColors.instance.subTextColor),
                          50.height,
                        ],
                      ),
                      CommonTextField(
                        controller: controller.passwordTextEditingController,
                        borderColor: AppColors.instance.boxBg,
                        labelText: "New password",
                        hintText: "Enter your new password",
                       validationType: ValidationType.validatePassword,
                      ),
                      20.height,
                      CommonTextField(
                        controller: controller.confirmPasswordTextEditingController,
                        borderColor: AppColors.instance.boxBg,
                        labelText: "Confirm new Password",
                        hintText: "Enter new confirm password",
                        validationType: ValidationType.validateConfirmPassword,
                        textInputAction: TextInputAction.done,

                      ),
                    ],
                  ),
                ),
              ),

              Column(
                children: [
                  CommonButton(
                    titleText: "Update Password",
                    onTap: () {
                      controller.checkCreateFunction();
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
