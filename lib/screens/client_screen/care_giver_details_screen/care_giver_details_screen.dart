import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:carely_caregiver/routes/app_routes.dart';
import 'package:carely_caregiver/screens/client_screen/care_giver_details_screen/controller/care_giver_details_controller.dart';
import 'package:carely_caregiver/widgets/default_background_template.dart';
import 'package:carely_caregiver/widgets/profile_avatar/profile_avatar.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../gen/assets.gen.dart';

class CareGiverDetailsScreen extends StatelessWidget {
  const CareGiverDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    CareGiverDetailsController controller =
        Get.find<CareGiverDetailsController>();
    final colors = AppColors.instance;

    return DefaultBackgroundTemplate(
      appBarTitle: 'Caregiver Profile',
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final profile = controller.caregiverProfile.value;
        if (profile == null) {
          return const Center(child: CommonText(text: "Failed to load profile"));
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ProfileAvatar(
                  size: 160,
                  imageUrl: profile.profileImage,
                  borderColor: colors.secondaryColor,
                  badgeIcon: profile.verifiedBadge ? Assets.icons.verify : null,
                  badgeSize: 40,
                ),
                12.height,
                CommonText(
                  text: profile.name,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  textColor: colors.textPrimary,
                ),
                8.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star_rounded, color: Colors.amber, size: 22),
                    4.width,
                    CommonText(
                      text: '${profile.averageRating.toStringAsFixed(1)} ',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      textColor: colors.textPrimary,
                    ),
                    CommonText(
                      text: '(${profile.totalReviews} reviews)',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      textColor: colors.secondaryText,
                    ),
                  ],
                ),
                8.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on_outlined, size: 20, color: colors.secondaryText),
                    4.width,
                    CommonText(
                      text: profile.location,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      textColor: colors.secondaryText,
                    ),
                  ],
                ),
                32.height,

                // ── Stats Cards ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _statCard(title: 'Jobs', value: '${profile.totalReviews}+'),
                    _statCard(title: 'EXP.', value: '${profile.experience} Yrs'),
                    _statCard(title: 'RESPONSE', value: '<10m'),
                  ],
                ),
                32.height,

                // ── Bio ──
                Align(
                  alignment: Alignment.centerLeft,
                  child: CommonText(
                    text: 'Bio',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    textColor: colors.textPrimary,
                  ),
                ),
                12.height,
                CommonText(
                  text: controller.bioDisplay,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  textColor: colors.textPrimary,
                  textAlign: TextAlign.start,
                  height: 1.5,
                  isDescription: true,
                  maxLines: 10,
                ),
                32.height,

                // ── Specialties ──
                Align(
                  alignment: Alignment.centerLeft,
                  child: CommonText(
                    text: 'Specialties',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    textColor: colors.textPrimary,
                  ),
                ),
                12.height,
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: profile.specialties
                        .map((s) => _specialtyChip(title: s))
                        .toList(),
                  ),
                ),
                32.height,

                // ── Availability ──
                Align(
                  alignment: Alignment.centerLeft,
                  child: CommonText(
                    text: 'Upcoming Availability',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    textColor: colors.textPrimary,
                  ),
                ),
                12.height,
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: controller.weekAvailability
                        .map((a) => _availabilityCard(
                              model: a,
                              isSelected: controller.selectedDate.value == a.date,
                              onTap: a.isAvailable ? () => controller.selectDate(a.date) : null,
                            ))
                        .toList(),
                  ),
                ),
                48.height,

                // ── Action ──
                CommonButton(
                  titleText: 'Book Appointment',
                  onTap: controller.selectedDate.value != null ? () {
                    Get.toNamed(AppRoutes.instance.bookCareGiverScreen, arguments: {
                      "profile": profile,
                      "selectedDate": controller.selectedDate.value,
                    });
                  } : null,
                  buttonWidth: double.infinity,
                  buttonHeight: 54,
                  buttonRadius: 14,
                ),
                20.height,
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _statCard({required String title, required String value}) {
    final colors = AppColors.instance;
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: colors.boxBg.withAlpha(50),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.secondaryColor.withAlpha(80), width: 1.5),
      ),
      child: Column(
        children: [
          CommonText(
            text: title,
            fontWeight: FontWeight.w600,
            fontSize: 12,
            textColor: colors.secondaryText,
          ),
          6.height,
          CommonText(
            text: value,
            fontWeight: FontWeight.w800,
            fontSize: 20,
            textColor: colors.textPrimary,
          ),
        ],
      ),
    );
  }

  Widget _specialtyChip({required String title}) {
    final colors = AppColors.instance;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colors.primary.withAlpha(15),
        borderRadius: BorderRadius.circular(50),
      ),
      child: CommonText(
        text: title,
        fontSize: 13,
        fontWeight: FontWeight.w600,
        textColor: colors.primary,
      ),
    );
  }

  Widget _availabilityCard({
    required AvailabilityModel model,
    required bool isSelected,
    VoidCallback? onTap,
  }) {
    final colors = AppColors.instance;
    final isAvailable = model.isAvailable;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected 
              ? colors.primary 
              : (isAvailable ? colors.white : colors.boxBg.withAlpha(50)),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? colors.primary : colors.boxBg,
            width: 1.5,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: colors.primary.withAlpha(40),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ] : null,
        ),
        child: Column(
          children: [
            CommonText(
              text: model.day,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              textColor: isSelected ? Colors.white.withAlpha(180) : colors.secondaryText,
            ),
            4.height,
            CommonText(
              text: model.dateLabel,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              textColor: isSelected ? Colors.white : (isAvailable ? colors.textPrimary : colors.textGrey),
            ),
            8.height,
            CommonText(
              text: model.status,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              textColor: isSelected ? Colors.white : (isAvailable ? colors.primary : colors.textGrey),
            ),
          ],
        ),
      ),
    );
  }
}
