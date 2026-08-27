import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:carely_caregiver/screens/profile_screens/personal_information_screen/controller/personal_info_controller.dart';
import 'package:carely_caregiver/screens/profile_screens/personal_information_screen/widgets/personal_info_widgets.dart';
import 'package:carely_caregiver/widgets/default_background_template.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PersonalInfoScreen extends GetView<PersonalInfoController> {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;

    return DefaultBackgroundTemplate(
      appBarTitle: 'Personal Information',
      child: Obx(
        () => Skeletonizer(
          enabled: controller.profileController.isLoading.value,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Profile Photo ──
                      EditableProfilePhoto(
                        file: controller.pickedImage.value,
                        imageUrl: controller.profileController.userModel.value?.profileImage,
                        onUploadTap: controller.pickProfileImage,
                      ),
                      SizedBox(height: 32.h),

                      // ── Name Field ──
                      CommonText(text: 'Full Name', fontSize: 16.sp, fontWeight: FontWeight.w500, textColor: colors.textPrimary),
                      SizedBox(height: 12.h),
                      CommonTextField(
                        controller: controller.nameController,
                        hintText: 'Enter your name',
                        backgroundColor: colors.textFiledBg,
                        borderColor: Colors.transparent,
                        borderRadius: 16.r,
                        validationType: ValidationType.notRequired,
                      ),
                      SizedBox(height: 20.h),

                      // ── Email Field ──
                      CommonText(text: 'Email Address', fontSize: 16.sp, fontWeight: FontWeight.w500, textColor: colors.textPrimary),
                      SizedBox(height: 12.h),
                      CommonTextField(
                        controller: controller.emailController,
                        isReadOnly: true,
                        hintText: 'Enter your email',
                        backgroundColor: colors.textFiledBg,
                        borderColor: Colors.transparent,
                        borderRadius: 16.r,
                        validationType: ValidationType.validateEmail,
                      ),
                      SizedBox(height: 20.h),

                      // ── Phone Field ──
                      CommonText(text: 'Phone Number', fontSize: 16.sp, fontWeight: FontWeight.w500, textColor: colors.textPrimary),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
                            decoration: BoxDecoration(
                              color: colors.textFiledBg,
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: CommonText(text: '+1', fontSize: 16.sp, fontWeight: FontWeight.w600, textColor: colors.textPrimary),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: CommonTextField(
                              controller: controller.phoneController,
                              hintText: 'Enter phone number',
                              backgroundColor: colors.textFiledBg,
                              borderColor: Colors.transparent,
                              borderRadius: 16.r,
                              validationType: ValidationType.notRequired,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 32.h),

                      // ── Medical Conditions ──
                      MedicalConditionsField(controller: controller.medicalController),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
              // ── Bottom Button ──
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 32.h),
                child: CommonButton(
                  isLoading: controller.isLoading.value,
                  titleText: 'Save Changes',
                  onTap: controller.saveChanges,
                  buttonWidth: double.infinity,
                  buttonHeight: 54.h,
                  buttonRadius: 16.r,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
