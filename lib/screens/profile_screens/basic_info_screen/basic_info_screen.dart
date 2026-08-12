import 'dart:io';

import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:carely_caregiver/widgets/app_image_picker.dart';
import 'package:carely_caregiver/widgets/dashed_circle_painter.dart';
import 'package:carely_caregiver/widgets/default_background_template.dart';
import 'package:carely_caregiver/widgets/phone_number_text_filed.dart';
import 'package:carely_caregiver/widgets/text/primary_text.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/basic_info_controller.dart';

class BasicInfoScreen extends StatelessWidget {
  const BasicInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final BasicInfoController controller = Get.find();

    return DefaultBackgroundTemplate(
      appBarTitle: 'Create Your Profile',
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
          child: Column(
            children: [
              const AuthScreenHeader(
                text: 'Basic Information',
              ),
              8.height,
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: AppSecondaryText(
                  textAlign: TextAlign.center,
                  text: "Let's start with the basics to help families get to know you.",
                ),
              ),
              36.height,
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(140, 140),
                      painter: DashedCirclePainter(
                        color: AppColors.instance.primary.withAlpha(150),
                        dashWidth: 6,
                        dashSpace: 4,
                        strokeWidth: 1.5,
                      ),
                      child: Obx(
                        () => Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.instance.primary.withAlpha(30),
                          ),
                          child: ClipOval(
                            child: controller.profileImage.value != null
                                ? Image.file(
                                    controller.profileImage.value!,
                                    fit: BoxFit.cover,
                                    width: 140,
                                    height: 140,
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.person,
                                        size: 60,
                                        color: AppColors.instance.textPrimary
                                            .withAlpha(180),
                                      ),
                                      4.height,
                                      Text(
                                        'Add Photo',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.instance.textPrimary
                                              .withAlpha(150),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: AppImagePicker(
                        width: 40,
                        height: 40,
                        borderRadius: 20,
                        pickerIcon: Icons.camera_alt,
                        onChanged: (file) {
                          if (file != null) {
                            controller.profileImage.value = File(file.path);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              24.height,
              const AppContentHeader(text: 'Profile Photo'),
              8.height,
              const AppSecondaryText(text: 'A clear photo helps build trust.'),
              32.height,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppContentHeader(text: 'Full Name'),
                  12.height,
                  CommonTextField(
                    controller: controller.fullNameController,
                    validationType: ValidationType.notRequired,
                    hintText: 'John Doe',
                    backgroundColor: AppColors.instance.textFiledBg,
                  ),
                  16.height,
                  const AppContentHeader(text: 'Email'),
                  12.height,
                  CommonTextField(
                    controller: controller.emailController,
                    isReadOnly: true,
                    validationType: ValidationType.notRequired,
                    hintText: 'Enter your email',
                    backgroundColor: AppColors.instance.textFiledBg,
                  ),
                  16.height,
                  const AppContentHeader(text: 'Phone Number'),
                  12.height,
                  PhoneTextField(
                    controller: controller.phoneController,
                  ),
                  48.height,
                  Obx(
                    () => CommonButton(
                      isLoading: controller.isLoading.value,
                      titleText: 'Next Step',
                      buttonColor: AppColors.instance.primary,
                      onTap: () {
                        controller.updateProfile();
                      },
                      buttonWidth: double.infinity,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
