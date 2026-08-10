import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constant/app_colors.dart';
import 'controller/change_password_screen_controller.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: ChangePasswordScreenController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(title: CommonText(text: "Change Password", fontSize: 20.sp), centerTitle: true),

          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal:20.w),
            child: Form(
              key: controller.formKey,
              child: Column(
                children: [
                  20.height,
                  CommonTextField(
                    controller: controller.oldPasswordTextEditingController,
                    borderColor: AppColors.instance.boxBg,
                    labelText: "Old Password",
                    validationType:ValidationType.validatePassword,
                  ),
                  20.height,
                  CommonTextField(
                    controller: controller.newPasswordTextEditingController,
                    borderColor: AppColors.instance.boxBg,
                    labelText: "New Password",
                    validationType: ValidationType.validatePassword,
                  ),
                  20.height,
                  CommonTextField(
                    controller: controller.confirmPasswordTextEditingController,
                    borderColor: AppColors.instance.boxBg,
                    labelText: "Confirm New Password",
                    validationType: ValidationType.validatePassword,
                    textInputAction: TextInputAction.done,
                  ),
                ],
              ),
            ),
          ),

          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal:20.w),
              child: CommonButton(
                titleText: "Submit",
                onTap: () {
                  controller.checkData();
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
