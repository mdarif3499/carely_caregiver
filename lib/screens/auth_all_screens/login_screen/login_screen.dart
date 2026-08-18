import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:carely_caregiver/routes/app_routes.dart';
import 'package:carely_caregiver/widgets/phone_number_text_filed.dart';
import 'entity/auth_entity.dart';
import 'package:carely_caregiver/widgets/text/primary_text.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carely_caregiver/gen/assets.gen.dart';

import '../../../utils/app_size.dart';
import 'controller/login_screen_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppSize.size = MediaQuery.of(context).size;

    return GetBuilder<LoginScreenController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColors.instance.screenBg,
          body: FormBuilder(
            entity: AuthEntity(),
            builder: (context, formKey, entity) {
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () => Center(
                            child: Column(
                              children: [
                                CommonImage(
                                  src: Assets.logo.appLogoPng.path,
                                  height: 70,
                                  width: 124,
                                ),
                                16.height,
                                AppPrimaryText(
                                  isDescription: false,
                                  text: controller.isSignInPage.value
                                      ? "Welcome Back!"
                                      : "Create Caregiver Account",
                                ),
                                8.height,
                                AppSecondaryText(
                                  textAlign: TextAlign.center,
                                  text: controller.isSignInPage.value
                                      ? "Access your dashboard and care plans."
                                      : "Join our community of healthcare professionals and start providing quality care.",
                                ),
                              ],
                            ),
                          ),
                        ),
                        38.height,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(
                              () => controller.isSignInPage.value
                                  ? const SizedBox()
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const AppContentHeader(
                                            text: 'Full Name'),
                                        12.height,
                                        CommonTextField(
                                          controller: controller
                                              .fullNameTextEditingController,
                                          validationType:
                                              ValidationType.validateRequired,
                                          hintText: 'Enter your Full Name',
                                          validation: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return "Full Name is required";
                                            }
                                            return null;
                                          },
                                        ),
                                        16.height,
                                      ],
                                    ),
                            ),
                            const AppContentHeader(text: 'Email'),
                            12.height,
                            CommonTextField(
                              controller: controller.emailTextEditingController,
                              validationType: ValidationType.validateEmail,
                              hintText: 'Enter your email',
                              validation: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Email is required";
                                }
                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$')
                                    .hasMatch(value)) {
                                  return "Enter a valid email";
                                }
                                return null;
                              },
                            ),
                            16.height,
                            Obx(
                              () => controller.isSignInPage.value
                                  ? const SizedBox()
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const AppContentHeader(
                                            text: 'Phone Number'),
                                        12.height,
                                        PhoneTextField(
                                          controller: controller
                                              .phoneTextEditingController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return "Phone number is required";
                                            }
                                            return null;
                                          },
                                        ),
                                        16.height,
                                      ],
                                    ),
                            ),
                            const AppContentHeader(text: 'Password'),
                            12.height,
                            CommonTextField(
                              controller:
                                  controller.passwordTextEditingController,
                              validationType: ValidationType.validatePassword,
                              hintText: 'Enter your Password',
                              validation: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Password is required";
                                }
                                if (value.length < 8) {
                                  return "Password must be at least 8 characters";
                                }
                                return null;
                              },
                            ),
                            8.height,
                            Obx(
                              () => controller.isSignInPage.value
                                  ? Align(
                                      alignment: Alignment.centerRight,
                                      child: GestureDetector(
                                        onTap: () {
                                          Get.toNamed(
                                              AppRoutes.instance.forgotScreen);
                                        },
                                        child: CommonText(
                                          text: 'Forgot Password?',
                                          textColor: AppColors.instance.error,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),
                            ),
                            32.height,
                            Obx(
                              () => CommonButton(
                                isLoading: controller.isLoading.value,
                                onTap: controller.isLoading.value 
                                  ? null 
                                  : () {
                                  if (formKey.currentState!.validate()) {
                                    if (controller.isSignInPage.value) {
                                      controller.loginUser();
                                    } else {
                                      Get.toNamed(
                                        AppRoutes.instance.welcomeScreen,
                                        arguments: {
                                          "name": controller
                                              .fullNameTextEditingController
                                              .text
                                              .trim(),
                                          "email": controller
                                              .emailTextEditingController.text
                                              .trim(),
                                          "phone": controller
                                              .phoneTextEditingController.text
                                              .trim(),
                                          "password": controller
                                              .passwordTextEditingController
                                              .text,
                                        },
                                      );
                                    }
                                  }
                                },
                                titleText: controller.isSignInPage.value
                                    ? 'Login'
                                    : 'Continue',
                                buttonWidth: double.infinity,
                              ),
                            ),
                            48.height,
                            Obx(
                              () => Align(
                                alignment: Alignment.center,
                                child: RichText(
                                  text: TextSpan(
                                    text: controller.isSignInPage.value
                                        ? "Don't have an account?"
                                        : "Already have an account?",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.instance.textPrimary,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: controller.isSignInPage.value
                                            ? ' Sign Up'
                                            : ' Login',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: AppColors.instance.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            controller.isSignInPage.value =
                                                !controller.isSignInPage.value;
                                          },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

Widget _googleSignIn() {
  return Column(
    children: [
      32.height,
      Row(
        children: [
          Expanded(child: Divider()),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16),
            child: CommonText(text: 'Or'),
          ),
          Expanded(child: Divider()),
        ],
      ),
      32.height,
      CommonButton(
        buttonColor: AppColors.instance.white,
        titleText: 'Continue with Google',
        titleColor: AppColors.instance.textPrimary,
        prefix: CommonImage(src: Assets.icons.google),
        buttonWidth: double.infinity,
      ),
    ],
  );
}
