import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:carely_caregiver/screens/client_screen/new_recipient_profile_screen/controller/health_profile_controller.dart';
import 'package:carely_caregiver/widgets/default_background_template.dart';
import 'package:carely_caregiver/widgets/text/primary_text.dart';
import 'package:carely_caregiver/widgets/app_multiline_text_field.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NewRecipientProfileScreen extends GetView<HealthProfileController> {
  const NewRecipientProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;

    return DefaultBackgroundTemplate(
      appBarTitle: 'Create Your Profile',
      child: Obx(
        () => Skeletonizer(
          enabled: controller.isLoading.value,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                  child: Column(
                    children: [
                      AuthScreenHeader(
                        text: 'Who are you seeking care for?',
                      ),
                      SizedBox(height: 8.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: AppSecondaryText(
                          textAlign: TextAlign.center,
                          text:
                              'Provide details about the family member or person needing assistance to help us find the best match.',
                        ),
                      ),
                      SizedBox(height: 36.h),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppContentHeader(text: 'Recipient Full Name'),
                          SizedBox(height: 12.h),
                          CommonTextField(
                            controller: controller.nameController,
                            hintText: 'John Doe',
                            backgroundColor: colors.textFiledBg,
                            borderColor: Colors.transparent,
                            borderRadius: 16.r,
                            validationType: ValidationType.notRequired,
                          ),
                          SizedBox(height: 20.h),
                          AppContentHeader(text: 'Your Relationship'),
                          SizedBox(height: 12.h),
                          CommonDropDown<String>(
                            hint: 'Select relationship',
                            enableInitalSelection: false,
                            items: controller.relationships,
                            backgroundColor: colors.textFiledBg,
                            borderColor: Colors.transparent,
                            borderRadius: 16.r,
                            onChanged: (val) =>
                                controller.selectedRelationship.value = val,
                            nameBuilder: (val) => val,
                          ),
                          SizedBox(height: 20.h),
                          AppContentHeader(
                              text: 'Health Considerations & Care Needs'),
                          SizedBox(height: 12.h),
                          AppMultilineTextField(
                            controller: controller.healthNeedsController,
                            hintText:
                                'List any allergies, mobility issues, or specific conditions (e.g., Diabetes, Dementia) ...',
                            backgroundColor: colors.textFiledBg,
                            borderColor: Colors.transparent,
                            borderRadius: 24.r,
                            height: 140.h,
                            validationType: ValidationType.notRequired,
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 32.h),
                child: Row(
                  children: [
                    Expanded(
                      child: CommonButton(
                        buttonColor: colors.boxBg,
                        titleText: 'Back',
                        titleColor: colors.textPrimary,
                        onTap: controller.cancel,
                        buttonWidth: double.infinity,
                        buttonHeight: 54.h,
                        buttonRadius: 16.r,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: CommonButton(
                        isLoading: controller.isLoading.value,
                        titleText: 'Continue',
                        onTap: controller.saveRecipient,
                        buttonWidth: double.infinity,
                        buttonHeight: 54.h,
                        buttonRadius: 16.r,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// VERIFY_EMAIL_API ====>>>> {success: true, message: Email verified successfully, data: {accessToken: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjZhODAwNzI2MDBjMDIwN2MzMmJmNmFjZCIsImVtYWlsIjoiZG9wb3Q3MDgzM0BiZWl3b2guY29tIiwicm9sZSI6IkNMSUVOVCIsImlhdCI6MTc4Njc3NTM2MiwiZXhwIjoxNzg2ODYxNzYyfQ.WaL611GN2vIh0K4HcrC8rNrVbd_pb97DbO1492TYI24, user: {id: 6a80072600c0207c32bf6acd, name: dopot, email: dopot70833@beiwoh.com, role: CLIENT, phone: (123) 456-7893, verificationStatus: verified, intakeCompleted: false}}}