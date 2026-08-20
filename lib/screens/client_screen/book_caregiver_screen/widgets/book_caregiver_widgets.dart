import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:carely_caregiver/gen/assets.gen.dart';
import 'package:carely_caregiver/screens/client_screen/book_caregiver_screen/controller/book_caregiver_controller.dart';
import 'package:carely_caregiver/screens/client_screen/find_caregiver_screen/controller/find_caregiver_controller.dart';
import 'package:carely_caregiver/widgets/profile_avatar/profile_avatar.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';

class CaregiverInfoCard extends StatelessWidget {
  final bool isHoursShow;
  final CaregiverModel? caregiver;

  const CaregiverInfoCard({
    super.key,
    this.isHoursShow = true,
    this.caregiver,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    
    final name = caregiver?.name ?? 'Sarah Jenkins, RN';
    final specialty = caregiver?.specialty ?? 'Certified Pediatric Caregiver';
    final rating = caregiver?.rating ?? 4.9;
    final rate = caregiver?.hourlyRate ?? 25.0;
    final imageUrl = caregiver?.avatarUrl ?? '';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ProfileAvatar(
            size: 68,
            imageUrl: imageUrl.isNotEmpty ? imageUrl : 'https://thumbs.dreamstime.com/b/young-male-doctor-close-up-happy-looking-camera-56751540.jpg',
            borderColor: colors.secondaryColor,
            badgeIcon: Assets.icons.verify,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  text: name,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  textColor: colors.textPrimary,
                ),
                const SizedBox(height: 4),
                CommonText(
                  text: specialty,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  textColor: colors.secondaryColor,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, size: 18, color: Colors.amber),
                    const SizedBox(width: 4),
                    CommonText(
                      text: rating.toStringAsFixed(1),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      textColor: colors.textPrimary,
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isHoursShow)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CommonText(
                  text: '\$${rate.toStringAsFixed(0)}/hr',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  textColor: colors.primary,
                ),
                CommonText(
                  text: 'per hour',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  textColor: colors.secondaryText,
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class TimeGroupLabel extends StatelessWidget {
  final String icon;
  final String label;

  const TimeGroupLabel({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 8),
        CommonText(
          text: label,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          textColor: colors.secondaryText,
        ),
      ],
    );
  }
}

class TimeChip extends StatelessWidget {
  final TimeSlot slot;
  final bool isSelected;
  final VoidCallback onTap;

  const TimeChip({
    super.key,
    required this.slot,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary.withAlpha(15) : colors.boxBg.withAlpha(50),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? colors.primary : colors.transparent,
            width: 1.5,
          ),
        ),
        child: CommonText(
          text: slot.label,
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          textColor: isSelected ? colors.primary : colors.textPrimary,
        ),
      ),
    );
  }
}
