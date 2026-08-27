import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
          body: Obx(
            () => Skeletonizer(
              enabled: controller.isLoading.value,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      CommonTextField(
                        controller: controller.oldPasswordTextEditingController,
                        borderColor: AppColors.instance.boxBg,
                        labelText: "Old Password",
                        validationType: ValidationType.validatePassword,
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
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 32.h),
              child: Obx(
                () => CommonButton(
                  isLoading: controller.isLoading.value,
                  titleText: "Submit",
                  buttonHeight: 54.h,
                  buttonWidth: double.infinity,
                  buttonRadius: 14.r,
                  onTap: () {
                    controller.checkData();
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
