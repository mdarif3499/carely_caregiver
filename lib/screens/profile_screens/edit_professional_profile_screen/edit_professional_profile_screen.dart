import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:carely_caregiver/screens/profile_screens/edit_professional_profile_screen/controller/edit_professional_profile_controller.dart';
import 'package:carely_caregiver/widgets/default_background_template.dart';
import 'package:carely_caregiver/widgets/skill_chip.dart';
import 'package:carely_caregiver/widgets/text/primary_text.dart';
import 'package:carely_caregiver/widgets/app_multiline_text_field.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EditProfessionalProfileScreen extends StatelessWidget {
  const EditProfessionalProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EditProfessionalProfileController>();

    return DefaultBackgroundTemplate(
      appBarTitle: 'Professional Profile',
      child: Obx(() {
        return Skeletonizer(
          enabled: controller.isLoading.value,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Professional Bio'),
                      SizedBox(height: 14.h),
                      AppMultilineTextField(
                        controller: controller.bioController,
                        hintText: 'Describe your expertise...',
                        validationType: ValidationType.notRequired,
                        borderRadius: 16.r,
                        backgroundColor: AppColors.instance.textFiledBg,
                      ),
                      SizedBox(height: 28.h),
                      _buildSectionTitle('Expertise & Specialties'),
                      SizedBox(height: 14.h),
                      _buildSpecialtiesGrid(controller),
                      SizedBox(height: 28.h),
                      _buildSectionTitle('Skills'),
                      SizedBox(height: 14.h),
                      _buildSkillsGrid(controller),
                      SizedBox(height: 28.h),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionTitle('Hourly Rate (\$)'),
                                SizedBox(height: 14.h),
                                CommonTextField(
                                  controller: controller.hourlyRateController,
                                  validationType: ValidationType.validateNumber,
                                  hintText: 'e.g. 25',
                                  borderRadius: 16.r,
                                  backgroundColor: AppColors.instance.textFiledBg,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionTitle('Experience'),
                                SizedBox(height: 14.h),
                                _buildExperienceDropdown(controller),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 28.h),
                      _buildSectionTitle('Location'),
                      SizedBox(height: 14.h),
                      CommonTextField(
                        controller: controller.cityController,
                        validationType: ValidationType.notRequired,
                        hintText: 'City',
                        borderRadius: 16.r,
                        backgroundColor: AppColors.instance.textFiledBg,
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          Expanded(
                            child: CommonTextField(
                              controller: controller.stateController,
                              validationType: ValidationType.notRequired,
                              hintText: 'State',
                              borderRadius: 16.r,
                              backgroundColor: AppColors.instance.textFiledBg,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: CommonTextField(
                              controller: controller.countryController,
                              validationType: ValidationType.notRequired,
                              hintText: 'Country',
                              borderRadius: 16.r,
                              backgroundColor: AppColors.instance.textFiledBg,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 32.h),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 32.h),
                child: CommonButton(
                  isLoading: controller.isSubmitting.value,
                  titleText: 'Save Changes',
                  onTap: () {
                    controller.updateProfile();
                  },
                  buttonWidth: double.infinity,
                  buttonHeight: 54.h,
                  buttonRadius: 16.r,
                ),
              ),
            ],
          ),
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
        children: controller.categories.map(
          (category) => SkillChip(
            label: category.name,
            isSelected: controller.selectedSpecialties.contains(category.id),
            onTap: () => controller.toggleSpecialty(category.id),
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
