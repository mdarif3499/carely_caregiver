import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:carely_caregiver/screens/profile_screens/profile_setup_screen/controller/profle_setup_screen_controller.dart';
import 'package:carely_caregiver/widgets/certification_card.dart';
import 'package:carely_caregiver/widgets/default_background_template.dart';
import 'package:carely_caregiver/widgets/skill_chip.dart';
import 'package:carely_caregiver/widgets/text/primary_text.dart';
import 'package:carely_caregiver/widgets/app_multiline_text_field.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfileSetupScreen extends StatelessWidget {
  const ProfileSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileSetupScreenController>();

    return DefaultBackgroundTemplate(
      appBarTitle: 'Profile Setup',
      child: Obx(
        () => Skeletonizer(
          enabled: controller.isLoading.value,
          child: Column(
            children: [
              // ── Scrollable body ──
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      SizedBox(height: 28.h),
                      _buildSectionTitle('Professional Bio'),
                      SizedBox(height: 14.h),
                      AppMultilineTextField(
                        controller: controller.bioController,
                        hintText: 'Tell families about yourself, your experience and why you love caregiving...',
                        validationType: ValidationType.notRequired,
                        borderRadius: 12.r,
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
                                  borderRadius: 12.r,
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
                        borderRadius: 12.r,
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
                              borderRadius: 12.r,
                              backgroundColor: AppColors.instance.textFiledBg,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: CommonTextField(
                              controller: controller.countryController,
                              validationType: ValidationType.notRequired,
                              hintText: 'Country',
                              borderRadius: 12.r,
                              backgroundColor: AppColors.instance.textFiledBg,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 28.h),
                      _buildSectionTitle('Certifications & Licenses'),
                      SizedBox(height: 14.h),
                      _buildCertificationsList(controller),
                      SizedBox(height: 8.h),
                    ],
                  ),
                ),
              ),

              // ── Fixed bottom buttons ──
              _buildBottomButtons(context, controller),
              20.height,
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────
  //  Header
  // ─────────────────────────────

  Widget _buildHeader() {
    return Center(
      child: Column(
        children: [
          AuthScreenHeader(text: 'Professional Details'),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: AppSecondaryText(
              textAlign: TextAlign.center,
              text:
                  'Tell us about your expertise and credentials\nto help families find the perfect match.',
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────
  //  Section title helper
  // ─────────────────────────────

  Widget _buildSectionTitle(String title) {
    return AppPrimaryText(
      text: title,
      fontSize: 20.sp,
      fontWeight: FontWeight.w700,
    );
  }

  // ─────────────────────────────
  //  Specialties grid
  // ─────────────────────────────

  Widget _buildSpecialtiesGrid(ProfileSetupScreenController controller) {
    return Obx(
      () => Wrap(
        spacing: 10.w,
        runSpacing: 10.h,
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

  // ─────────────────────────────
  //  Skills grid
  // ─────────────────────────────

  Widget _buildSkillsGrid(ProfileSetupScreenController controller) {
    return Obx(
      () => Wrap(
        spacing: 10.w,
        runSpacing: 10.h,
        children: [
          // Skill chips
          ...controller.visibleSkills.map(
            (skill) => SkillChip(
              label: skill,
              isSelected: controller.selectedSkills.contains(skill),
              onTap: () => controller.toggleSkill(skill),
            ),
          ),

          // "+ More" toggle
          if (controller.hasMoreSkills)
            GestureDetector(
              onTap: controller.expandSkills,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 10.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.instance.primary.withAlpha(50),
                  borderRadius: BorderRadius.circular(50.r),
                  border: Border.all(
                    color: AppColors.instance.primary,
                    width: 1.5.w,
                  ),
                ),
                child: CommonText(
                  text: '+ More',
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  textColor: AppColors.instance.primary,
                  isDescription: true,
                  preventScaling: true,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ─────────────────────────────
  //  Experience dropdown
  // ─────────────────────────────

  Widget _buildExperienceDropdown(ProfileSetupScreenController controller) {
    return CommonDropDown<String>(
      hint: 'Select years of experience',
      enableInitalSelection: false,
      items: controller.experienceOptions,
      backgroundColor: AppColors.instance.textFiledBg,
      borderColor: AppColors.instance.transparent,
      borderRadius: 12.r,
      onChanged: controller.onExperienceChanged,
      nameBuilder: (val) => val,
    );
  }

  // ─────────────────────────────
  //  Certifications list
  // ─────────────────────────────

  Widget _buildCertificationsList(ProfileSetupScreenController controller) {
    return Obx(
      () => Column(
        children: [
          // Existing certifications
          ...controller.certifications.asMap().entries.map(
            (entry) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: CertificationCard(
                title: entry.value['title']!,
                subtitle: entry.value['subtitle']!,
                onDelete: () => controller.deleteCertification(entry.key),
              ),
            ),
          ),

          // Uploading state
          if (controller.isUploading.value)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),

          // Add new card
          if (!controller.isUploading.value)
            AddCertificationCard(
              onTap: () {
                controller.pickAndUploadFile();
              },
            ),
        ],
      ),
    );
  }

  // ─────────────────────────────
  //  Bottom buttons
  // ─────────────────────────────

  Widget _buildBottomButtons(BuildContext context, ProfileSetupScreenController controller) {
    return Container(
      color: AppColors.instance.screenBg,
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
      child: Row(
        children: [
          Expanded(
            child: CommonButton(
              buttonColor: AppColors.instance.boxBg,
              titleText: 'Back',
              titleColor: AppColors.instance.textPrimary,
              onTap: () {
                Get.back();
              },
              buttonWidth: double.infinity,
              buttonHeight: 54.h,
              buttonRadius: 16.r,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Obx(
              () => CommonButton(
                isLoading: controller.isSubmitting.value,
                titleText: 'Continue',
                buttonWidth: double.infinity,
                buttonHeight: 54.h,
                buttonRadius: 16.r,
                elevation: 0,
                onTap: () {
                  controller.updateProfile();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
