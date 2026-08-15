import 'dart:io';

import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:carely_caregiver/screens/client_screen/new_recipient_profile_screen/controller/health_profile_controller.dart';
import 'package:carely_caregiver/widgets/app_image_picker.dart';
import 'package:carely_caregiver/widgets/dashed_circle_painter.dart';
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: AppSecondaryText(
                      textAlign: TextAlign.center,
                      text:
                          'Provide details about the family member or person needing assistance to help us find the best match.',
                    ),
                  ),
                  const SizedBox(height: 36),

                  // ── Photo Picker ──
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomPaint(
                          size: const Size(140, 140),
                          painter: DashedCirclePainter(
                            color: colors.primary.withAlpha(150),
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
                                color: colors.primary.withAlpha(30),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.person,
                                            size: 60,
                                            color: colors.textPrimary
                                                .withAlpha(180),
                                          ),
                                          4.height,
                                          Text(
                                            'Add Photo',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: colors.textPrimary
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
                          bottom: 5,
                          right: 5,
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
                  const SizedBox(height: 24),
                  const AppContentHeader(text: 'Profile Photo'),
                  const SizedBox(height: 8),
                  const AppSecondaryText(text: 'A clear photo helps build trust.'),
                  const SizedBox(height: 32),

                  // ── Fields ──
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
          // ── Bottom Buttons ──
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
                  child: CommonButton(
                    titleText: 'Continue',
                    onTap: controller.saveRecipient,
                    buttonWidth: double.infinity,
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
