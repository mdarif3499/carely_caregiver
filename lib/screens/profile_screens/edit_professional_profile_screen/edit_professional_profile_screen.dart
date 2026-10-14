import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:carely_caregiver/screens/profile_screens/edit_professional_profile_screen/controller/edit_professional_profile_controller.dart';
import 'package:carely_caregiver/widgets/default_background_template.dart';
import 'package:carely_caregiver/widgets/skill_chip.dart';
import 'package:carely_caregiver/widgets/text/primary_text.dart';
import 'package:carely_caregiver/widgets/app_multiline_text_field.dart';
import 'package:carely_caregiver/widgets/app_text_field.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EditProfessionalProfileScreen extends StatefulWidget {
  const EditProfessionalProfileScreen({super.key});

  @override
  State<EditProfessionalProfileScreen> createState() =>
      _EditProfessionalProfileScreenState();
}

class _EditProfessionalProfileScreenState
    extends State<EditProfessionalProfileScreen> {
  late final EditProfessionalProfileController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<EditProfessionalProfileController>();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultBackgroundTemplate(
      appBarTitle: 'Professional Profile',
      child: Obx(() {
        return Skeletonizer(
          enabled: controller.isLoading.value,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
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
                      _buildSkillsGrid(context, controller),
                      SizedBox(height: 28.h),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionTitle('Hourly Rate (\$)'),
                                SizedBox(height: 14.h),
                                AppTextField(
                                  controller: controller.hourlyRateController,
                                  validationType: ValidationType.validateNumber,
                                  hintText: 'e.g. 25',
                                  borderRadius: 16.r,
                                  backgroundColor:
                                      AppColors.instance.textFiledBg,
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
                      AppTextField(
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
                            child: AppTextField(
                              controller: controller.stateController,
                              validationType: ValidationType.notRequired,
                              hintText: 'State',
                              borderRadius: 16.r,
                              backgroundColor: AppColors.instance.textFiledBg,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: AppTextField(
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
        children: controller.categories
            .map(
              (category) => SkillChip(
                label: category.name,
                isSelected: controller.isSpecialtySelected(category),
                onTap: () => controller.toggleSpecialty(category),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildSkillsGrid(
      BuildContext context, EditProfessionalProfileController controller) {
    return Obx(
      () => Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          ...controller.allSkills.map(
            (skill) => SkillChip(
              label: skill,
              isSelected: controller.isSkillSelected(skill),
              onTap: () => controller.toggleSkill(skill),
            ),
          ),
          GestureDetector(
            onTap: () => _showAddSkillDialog(context, controller),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.instance.primary.withAlpha(30),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: AppColors.instance.primary,
                  width: 1.2,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_rounded,
                      size: 18.sp, color: AppColors.instance.primary),
                  SizedBox(width: 4.w),
                  CommonText(
                    text: 'Add Skill',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    textColor: AppColors.instance.primary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddSkillDialog(
      BuildContext context, EditProfessionalProfileController controller) {
    final textController = TextEditingController();
    Get.dialog(
      AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: const AppPrimaryText(
            text: 'Add Skill', fontSize: 18, fontWeight: FontWeight.w600),
        content: AppTextField(
          controller: textController,
          hintText: 'e.g. CPR Certified',
          validationType: ValidationType.notRequired,
          borderRadius: 12.r,
          backgroundColor: AppColors.instance.textFiledBg,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (textController.text.trim().isNotEmpty) {
                controller.addCustomSkill(textController.text.trim());
                Get.back();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.instance.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r)),
            ),
            child: const Text('Add', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceDropdown(
      EditProfessionalProfileController controller) {
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
