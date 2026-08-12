import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:carely_caregiver/routes/app_routes.dart';
import 'package:carely_caregiver/screens/profile_screens/profile_setup_screen/controller/profle_setup_screen_controller.dart';
import 'package:carely_caregiver/widgets/certification_card.dart';
import 'package:carely_caregiver/widgets/default_background_template.dart';
import 'package:carely_caregiver/widgets/skill_chip.dart';
import 'package:carely_caregiver/widgets/text/primary_text.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileSetupScreen extends StatelessWidget {
  const ProfileSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileSetupScreenController>();

    return DefaultBackgroundTemplate(
      appBarTitle: 'Profile Setup',
      child: Column(
        children: [
          // ── Scrollable body ──
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 28),
                  _buildSectionTitle('Skills & Specializations'),
                  const SizedBox(height: 14),
                  _buildSkillsGrid(controller),
                  const SizedBox(height: 28),
                  _buildSectionTitle('Work Experience'),
                  const SizedBox(height: 10),
                  AppContentHeader(text: 'Total Years in Caregiving'),
                  const SizedBox(height: 10),
                  _buildExperienceDropdown(controller),
                  const SizedBox(height: 28),
                  _buildSectionTitle('Certifications & Licenses'),
                  const SizedBox(height: 14),
                  _buildCertificationsList(controller),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),

          // ── Fixed bottom buttons ──
          _buildBottomButtons(context),
          20.height,
        ],
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
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
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
      fontSize: 20,
      fontWeight: FontWeight.w700,
    );
  }

  // ─────────────────────────────
  //  Skills grid
  // ─────────────────────────────

  Widget _buildSkillsGrid(ProfileSetupScreenController controller) {
    return Obx(
      () => Wrap(
        spacing: 10,
        runSpacing: 10,
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.instance.primary.withAlpha(50),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: AppColors.instance.primary,
                    width: 1.5,
                  ),
                ),
                child: CommonText(
                  text: '+ More',
                  fontSize: 13,
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
      borderRadius: 12,
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
              padding: const EdgeInsets.only(bottom: 12),
              child: CertificationCard(
                title: entry.value['title']!,
                subtitle: entry.value['subtitle']!,
                onDelete: () => controller.deleteCertification(entry.key),
              ),
            ),
          ),

          // Add new card
          AddCertificationCard(
            onTap: () {
              // TODO: open add certification bottom sheet
            },
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────
  //  Bottom buttons
  // ─────────────────────────────

  Widget _buildBottomButtons(BuildContext context) {
    return Container(
      color: AppColors.instance.screenBg,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
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
            ),
          ),
          16.width,
          Expanded(
            child: CommonButton(
              titleText: 'Continue',
              buttonWidth: double.infinity,
              elevation: 0,
              onTap: () {
                Get.offAllNamed(
                  AppRoutes.instance.appNavigationScreen,
                  arguments: {"isClient": false},
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
