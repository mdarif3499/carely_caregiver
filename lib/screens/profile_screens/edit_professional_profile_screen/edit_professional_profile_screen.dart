import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:carely_caregiver/screens/profile_screens/edit_professional_profile_screen/controller/edit_professional_profile_controller.dart';
import 'package:carely_caregiver/widgets/default_background_template.dart';
import 'package:carely_caregiver/widgets/skill_chip.dart';
import 'package:carely_caregiver/widgets/text/primary_text.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfessionalProfileScreen extends StatelessWidget {
  const EditProfessionalProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditProfessionalProfileController());

    return DefaultBackgroundTemplate(
      appBarTitle: 'Professional Profile',
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Professional Bio'),
                    const SizedBox(height: 14),
                    CommonMultilineTextField(
                      controller: controller.bioController,
                      hintText: 'Describe your expertise...',
                      validationType: ValidationType.notRequired,
                      borderRadius: 16,
                      backgroundColor: AppColors.instance.textFiledBg,
                    ),
                    const SizedBox(height: 28),
                    _buildSectionTitle('Expertise & Specialties'),
                    const SizedBox(height: 14),
                    _buildSpecialtiesGrid(controller),
                    const SizedBox(height: 28),
                    _buildSectionTitle('Skills'),
                    const SizedBox(height: 14),
                    _buildSkillsGrid(controller),
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle('Hourly Rate (\$)'),
                              const SizedBox(height: 14),
                              CommonTextField(
                                controller: controller.hourlyRateController,
                                validationType: ValidationType.validateNumber,
                                hintText: 'e.g. 25',
                                borderRadius: 16,
                                backgroundColor: AppColors.instance.textFiledBg,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle('Experience'),
                              const SizedBox(height: 14),
                              _buildExperienceDropdown(controller),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    _buildSectionTitle('Location'),
                    const SizedBox(height: 14),
                    CommonTextField(
                      controller: controller.cityController,
                      validationType: ValidationType.notRequired,
                      hintText: 'City',
                      borderRadius: 16,
                      backgroundColor: AppColors.instance.textFiledBg,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: CommonTextField(
                            controller: controller.stateController,
                            validationType: ValidationType.notRequired,
                            hintText: 'State',
                            borderRadius: 16,
                            backgroundColor: AppColors.instance.textFiledBg,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CommonTextField(
                            controller: controller.countryController,
                            validationType: ValidationType.notRequired,
                            hintText: 'Country',
                            borderRadius: 16,
                            backgroundColor: AppColors.instance.textFiledBg,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              child: CommonButton(
                isLoading: controller.isSubmitting.value,
                titleText: 'Save Changes',
                onTap: () {
                  controller.updateProfile();
                },
                buttonWidth: double.infinity,
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSectionTitle(String title) {
    return AppPrimaryText(
      text: title,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    );
  }

  Widget _buildSpecialtiesGrid(EditProfessionalProfileController controller) {
    return Obx(
      () => Wrap(
        spacing: 10,
        runSpacing: 10,
        children: controller.allSpecialties.map(
          (specialty) => SkillChip(
            label: specialty,
            isSelected: controller.selectedSpecialties.contains(specialty),
            onTap: () => controller.toggleSpecialty(specialty),
          ),
        ).toList(),
      ),
    );
  }

  Widget _buildSkillsGrid(EditProfessionalProfileController controller) {
    return Obx(
      () => Wrap(
        spacing: 10,
        runSpacing: 10,
        children: controller.allSkills.map(
          (skill) => SkillChip(
            label: skill,
            isSelected: controller.selectedSkills.contains(skill),
            onTap: () => controller.toggleSkill(skill),
          ),
        ).toList(),
      ),
    );
  }

  Widget _buildExperienceDropdown(EditProfessionalProfileController controller) {
    return CommonDropDown<String>(
      hint: 'Experience',
      enableInitalSelection: controller.selectedExperience.value != null,
      initalValue: controller.selectedExperience.value,
      items: controller.experienceOptions,
      backgroundColor: AppColors.instance.textFiledBg,
      borderColor: AppColors.instance.transparent,
      borderRadius: 16,
      onChanged: controller.onExperienceChanged,
      nameBuilder: (val) => val,
    );
  }
}
