import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:carely_caregiver/screens/profile_screens/personal_information_screen/controller/personal_info_controller.dart';
import 'package:carely_caregiver/screens/profile_screens/personal_information_screen/widgets/personal_info_widgets.dart';
import 'package:carely_caregiver/widgets/default_background_template.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PersonalInfoScreen extends GetView<PersonalInfoController> {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;

    return DefaultBackgroundTemplate(
      appBarTitle: 'Personal Information',
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Profile Photo ──
                  Obx(
                    () => EditableProfilePhoto(
                      file: controller.pickedImage.value,
                      imageUrl: controller.profileController.userModel.value?.profileImage,
                      onUploadTap: controller.pickProfileImage,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // ── Name Field ──
                  CommonText(text: 'Full Name', fontSize: 16, fontWeight: FontWeight.w500, textColor: colors.textPrimary),
                  const SizedBox(height: 12),
                  CommonTextField(
                    controller: controller.nameController,
                    hintText: 'Enter your name',
                    backgroundColor: colors.textFiledBg,
                    borderColor: Colors.transparent,
                    borderRadius: 16,
                    validationType: ValidationType.notRequired,
                  ),
                  const SizedBox(height: 20),

                  // ── Email Field ──
                  CommonText(text: 'Email Address', fontSize: 16, fontWeight: FontWeight.w500, textColor: colors.textPrimary),
                  const SizedBox(height: 12),
                  CommonTextField(
                    controller: controller.emailController,
                    isReadOnly: true,
                    hintText: 'Enter your email',
                    backgroundColor: colors.textFiledBg,
                    borderColor: Colors.transparent,
                    borderRadius: 16,
                    validationType: ValidationType.validateEmail,
                  ),
                  const SizedBox(height: 20),

                  // ── Phone Field ──
                  CommonText(text: 'Phone Number', fontSize: 16, fontWeight: FontWeight.w500, textColor: colors.textPrimary),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                        decoration: BoxDecoration(
                          color: colors.textFiledBg,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: CommonText(text: '+1', fontSize: 16, fontWeight: FontWeight.w600, textColor: colors.textPrimary),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CommonTextField(
                          controller: controller.phoneController,
                          hintText: 'Enter phone number',
                          backgroundColor: colors.textFiledBg,
                          borderColor: Colors.transparent,
                          borderRadius: 16,
                          validationType: ValidationType.notRequired,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // ── Medical Conditions ──
                  MedicalConditionsField(controller: controller.medicalController),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          // ── Bottom Button ──
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            child: Obx(
              () => CommonButton(
                isLoading: controller.isLoading.value,
                titleText: 'Save Changes',
                onTap: controller.saveChanges,
                buttonWidth: double.infinity,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
