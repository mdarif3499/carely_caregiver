import 'package:core_kit/core_kit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constant/app_assert_image.dart';
import '../../../constant/app_colors.dart';
import '../../../constant/app_constant.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/app_size.dart';
import 'controller/sign_up_controller.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppSize.size = MediaQuery.of(context).size;

    return Scaffold(
      body: GetBuilder(
        init: SignUpController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(title: CommonText(text: "Create New Account", fontSize: 18), centerTitle: true, surfaceTintColor: AppColors.instance.white50,),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20.0)),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      CommonImage(src: AppAssertImage.instance.logo, width: AppSize.size.width * 0.6),
                      10.height,
                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                30.width,
                                Radio(
                                  value: true,
                                  groupValue: controller.userTypes.value,
                                  activeColor: AppColors.instance.primary300,
                                  onChanged: (value) {
                                    controller.changeUserType(true);
                                  },
                                ),

                                CommonText(text: "User", fontWeight: FontWeight.bold, fontSize: 20),
                              ],
                            ),

                            Row(
                              children: [
                                Radio(
                                  value: false,
                                  groupValue: controller.userTypes.value,
                                  activeColor: AppColors.instance.primary300,
                                  onChanged: (value) {
                                    controller.changeUserType(false);
                                  },
                                ),

                                CommonText(text: "Agency", fontWeight: FontWeight.bold, fontSize: 20),
                                30.width,
                              ],
                            ),
                          ],
                        ),
                      ),
                      10.height,
                      CommonTextField(
                        controller: controller.fullNameTextEditingController,
                        borderColor: AppColors.instance.boxBg,
                        labelText: "Full Name",
                        hintText: "Enter full name",
                        validationType: ValidationType.notRequired,
                      ),
                      20.height,
                      CommonTextField(
                        controller: controller.emailTextEditingController,
                        borderColor: AppColors.instance.boxBg,
                        labelText: "Email",
                        hintText: "Enter your e-mail",
                        validationType: ValidationType.validateEmail,
                      ),
                     20.height,
                      CommonTextField(
                        controller: controller.locationTextEditingController,
                        borderColor: AppColors.instance.boxBg,
                        labelText: "Location",
                        hintText: "Enter your location",
                        validationType: ValidationType.notRequired,
                      ),
                      20.height,
                      CommonTextField(
                        controller: controller.passwordTextEditingController,
                        borderColor: AppColors.instance.boxBg,
                        labelText: "Password",
                        hintText: "Enter your password",
                        validationType: ValidationType.validatePassword,
                      ),
                      20.height,
                      CommonTextField(
                        controller: controller.confirmPasswordTextEditingController,
                        borderColor: AppColors.instance.boxBg,
                        labelText: "Confirm Password",
                        hintText: "Enter your confirm password",
                        textInputAction: TextInputAction.done,
                        validationType: ValidationType.validateConfirmPassword,
                      ),
                      20.height,
                      Obx(
                        () => Row(
                          children: [
                            Theme(
                              data: ThemeData(unselectedWidgetColor: AppColors.instance.primary200),
                              child: Checkbox(
                                activeColor: AppColors.instance.white50,

                                side: WidgetStateBorderSide.resolveWith((states) {
                                  if (states.contains(WidgetState.selected)) {
                                    return BorderSide(color: AppColors.instance.primary200);
                                  } else {
                                    return BorderSide(color: AppColors.instance.dark300);
                                  }
                                }),
                                value: controller.termsAndConditions.value,
                                checkColor: AppColors.instance.primary200,
                                fillColor: WidgetStatePropertyAll(AppColors.instance.white50),
                                shape: RoundedRectangleBorder(side: BorderSide(color: AppColors.instance.primary200), borderRadius: BorderRadius.circular(AppSize.width(value: 5.0))),
                                onChanged: (value) {
                                  controller.changeTermsAndConditions(value ?? false);
                                },
                              ),
                            ),

                            Expanded(
                              child: Text.rich(
                                TextSpan(
                                  text: "By creating an account, I agree to the ",
                                  style: TextStyle(color: AppColors.instance.dark400, fontFamily: AppConstant.instance.font, height: 1.5),
                                  children: [
                                    TextSpan(
                                      text: "Terms & Conditions",
                                      style: TextStyle(color: AppColors.instance.primary),
                                      recognizer:
                                          TapGestureRecognizer()
                                            ..onTap = () {
                                              Get.toNamed(AppRoutes.instance.termsAndConditions);
                                            },
                                    ),
                                    TextSpan(text: " & ", style: TextStyle(color: AppColors.instance.dark400)),
                                    TextSpan(
                                      text: "Privacy Policy",
                                      style: TextStyle(color: AppColors.instance.primary),
                                      recognizer:
                                          TapGestureRecognizer()
                                            ..onTap = () {
                                              Get.toNamed(AppRoutes.instance.privacyPolicy);
                                            },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                     30.height,
                      Obx(
                        () => CommonButton(
                          buttonColor: controller.termsAndConditions.value ? AppColors.instance.primary : AppColors.instance.dark100,
                          borderColor: controller.termsAndConditions.value ? AppColors.instance.primary : AppColors.instance.dark100,
                          titleText: "Next",
                          onTap:
                              controller.termsAndConditions.value
                                  ? () {
                                    controller.checkValidation();
                                  }
                                  : null,
                        ),
                      ),
                     30.height,
                      Text.rich(
                        TextSpan(
                          text: "Already have an account? ",
                          style: TextStyle(color: AppColors.instance.dark400, fontFamily: AppConstant.instance.font, height: 1.5),
                          children: [
                            TextSpan(
                              text: "Sign In",
                              style: TextStyle(color: AppColors.instance.primary, decoration: TextDecoration.underline, decorationColor: AppColors.instance.primary),
                              recognizer:
                                  TapGestureRecognizer()
                                    ..onTap = () {
                                      Get.back();
                                    },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
