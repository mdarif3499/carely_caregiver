import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:carely_caregiver/screens/client_screen/new_recipient_profile_screen/controller/health_profile_controller.dart';
import 'package:carely_caregiver/widgets/default_background_template.dart';
import 'package:carely_caregiver/widgets/text/primary_text.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewRecipientProfileScreen extends GetView<HealthProfileController> {
  const NewRecipientProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;

    return DefaultBackgroundTemplate(
      appBarTitle: 'Create Your Profile',
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                children: [
                  const AuthScreenHeader(
                    text: 'Who are you seeking care for?',
                  ),
                  const SizedBox(height: 8),
                  const Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: AppSecondaryText(
                      textAlign: TextAlign.center,
                      text:
                          'Provide details about the family member or person needing assistance to help us find the best match.',
                    ),
                  ),
                  const SizedBox(height: 36),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppContentHeader(text: 'Recipient Full Name'),
                      const SizedBox(height: 12),
                      CommonTextField(
                        controller: controller.nameController,
                        hintText: 'John Doe',
                        backgroundColor: colors.textFiledBg,
                        borderColor: Colors.transparent,
                        borderRadius: 16,
                        validationType: ValidationType.notRequired,
                      ),
                      const SizedBox(height: 20),
                      const AppContentHeader(text: 'Your Relationship'),
                      const SizedBox(height: 12),
                      CommonDropDown<String>(
                        hint: 'Select relationship',
                        enableInitalSelection: false,
                        items: controller.relationships,
                        backgroundColor: colors.textFiledBg,
                        borderColor: Colors.transparent,
                        borderRadius: 16,
                        onChanged: (val) =>
                            controller.selectedRelationship.value = val,
                        nameBuilder: (val) => val,
                      ),
                      const SizedBox(height: 20),
                      const AppContentHeader(
                          text: 'Health Considerations & Care Needs'),
                      const SizedBox(height: 12),
                      CommonMultilineTextField(
                        controller: controller.healthNeedsController,
                        hintText:
                            'List any allergies, mobility issues, or specific conditions (e.g., Diabetes, Dementia) ...',
                        backgroundColor: colors.textFiledBg,
                        borderColor: Colors.transparent,
                        borderRadius: 24,
                        height: 140,
                        validationType: ValidationType.notRequired,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),


      ///      {: true message: Email verified successfully, data: {accessToken: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjZhODAwNzI2MDBjMDIwN2MzMmJmNmFjZCIsImVtYWlsIjoiZG9wb3Q3MDgzM0BiZWl3b2guY29tIiwicm9sZSI6IkNMSUVOVCIsImlhdCI6MTc4Njc3NTM2MiwiZXhwIjoxNzg2ODYxNzYyfQ.WaL611GN2vIh0K4HcrC8rNrVbd_pb97DbO1492TYI24, user: {id: 6a80072600c0207c32bf6acd, name: dopot, email: dopot70833@beiwoh.com, role: CLIENT, phone: (123) 456-7893, verificationStatus: verified, intakeCompleted: false}}}



          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            child: Row(
              children: [
                Expanded(
                  child: CommonButton(
                    buttonColor: colors.boxBg,
                    titleText: 'Back',
                    titleColor: colors.textPrimary,
                    onTap: controller.cancel,
                    buttonWidth: double.infinity,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Obx(
                    () => CommonButton(
                      isLoading: controller.isLoading.value,
                      titleText: 'Continue',
                      onTap: controller.saveRecipient,
                      buttonWidth: double.infinity,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// VERIFY_EMAIL_API ====>>>> {success: true, message: Email verified successfully, data: {accessToken: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjZhODAwNzI2MDBjMDIwN2MzMmJmNmFjZCIsImVtYWlsIjoiZG9wb3Q3MDgzM0BiZWl3b2guY29tIiwicm9sZSI6IkNMSUVOVCIsImlhdCI6MTc4Njc3NTM2MiwiZXhwIjoxNzg2ODYxNzYyfQ.WaL611GN2vIh0K4HcrC8rNrVbd_pb97DbO1492TYI24, user: {id: 6a80072600c0207c32bf6acd, name: dopot, email: dopot70833@beiwoh.com, role: CLIENT, phone: (123) 456-7893, verificationStatus: verified, intakeCompleted: false}}}