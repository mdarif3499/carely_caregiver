import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:carely_caregiver/screens/client_screen/new_recipient_profile_screen/controller/health_profile_controller.dart';
import 'package:carely_caregiver/screens/client_screen/new_recipient_profile_screen/widgets/health_profile_widgets.dart';
import 'package:carely_caregiver/widgets/default_background_template.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewRecipientProfileScreen extends GetView<HealthProfileController> {
  const NewRecipientProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;

    return DefaultBackgroundTemplate(
      appBarTitle: 'New Care Recipients Profile',
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CommonText(
                    text: 'Health Profile',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                  const SizedBox(height: 8),
                  CommonText(
                    text: 'Tell us more about the person who needs care so we can match the best provider.',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    textColor: colors.secondaryText,
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 32),

                  // ── Photo Picker ──
                  HealthProfilePhotoPicker(onUploadTap: () {}),
                  const SizedBox(height: 32),

                  // ── Name ──
                  const CommonText(text: 'Full Name', fontSize: 16, fontWeight: FontWeight.w500),
                  const SizedBox(height: 12),
                  CommonTextField(
                    controller: controller.nameController,
                    hintText: 'Enter name',
                    backgroundColor: colors.textFiledBg,
                    borderColor: Colors.transparent,
                    borderRadius: 16,
                    validationType: ValidationType.notRequired,
                  ),
                  const SizedBox(height: 20),

                  // ── DOB & Gender ──
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CommonText(text: 'Date of Birth', fontSize: 16, fontWeight: FontWeight.w500),
                            const SizedBox(height: 10),
                            CommonTextField(
                              controller: controller.dobController,
                              hintText: 'mm/dd/yyyy',
                              backgroundColor: colors.textFiledBg,
                              borderColor: Colors.transparent,
                              borderRadius: 16,
                              suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
                              validationType: ValidationType.notRequired,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CommonText(text: 'Gender', fontSize: 16, fontWeight: FontWeight.w500),
                            const SizedBox(height: 10),
                            Obx(
                              () => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: colors.textFiledBg,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: controller.selectedGender.value == 'Select' ? null : controller.selectedGender.value,
                                    hint: CommonText(text: 'Select', fontSize: 14, textColor: colors.secondaryText),
                                    isExpanded: true,
                                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                                    items: controller.genders.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (val) => controller.selectedGender.value = val!,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ── Language ──
                  const CommonText(text: 'Primary Language', fontSize: 16, fontWeight: FontWeight.w500),
                  const SizedBox(height: 12),
                  Obx(
                    () => LanguageSelector(
                      options: controller.languages,
                      selected: controller.selectedLanguage.value,
                      onSelected: (val) => controller.selectedLanguage.value = val,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // ── Medical Conditions ──
                  const CommonText(
                    text: 'Medical Conditions & Allergies',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: controller.medicalController,
                    maxLines: 4,
                    style: TextStyle(fontSize: 15, color: colors.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Example: Type 2 Diabetes, Penicillin allergy, limited mobility in left leg ...',
                      hintStyle: TextStyle(fontSize: 14, color: colors.secondaryText.withAlpha(150)),
                      filled: true,
                      fillColor: colors.textFiledBg,
                      contentPadding: const EdgeInsets.all(20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          // ── Bottom Buttons ──
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            child: Column(
              children: [
                CommonButton(
                  titleText: 'Save Recipient',
                  onTap: controller.saveRecipient,
                  buttonWidth: double.infinity,
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: controller.cancel,
                  child: CommonText(
                    text: 'Cancel and Return',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    textColor: colors.secondaryText,
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
