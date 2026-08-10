import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';

class CertificationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onDelete;
  final Widget? icon;

  const CertificationCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.onDelete,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.instance.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.instance.border, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon box
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.instance.boxBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child:
                icon ??
                Icon(
                  Icons.badge_outlined,
                  color: AppColors.instance.primary,
                  size: 24,
                ),
          ),
          const SizedBox(width: 12),
          // Text info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  text: title,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  textColor: AppColors.instance.textPrimary,
                  textAlign: TextAlign.start,
                  isDescription: true,
                  preventScaling: true,
                ),
                const SizedBox(height: 3),
                CommonText(
                  text: subtitle,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  textColor: AppColors.instance.secondaryText,
                  textAlign: TextAlign.start,
                  isDescription: true,
                  preventScaling: true,
                ),
              ],
            ),
          ),
          // Delete button
          if (onDelete != null)
            GestureDetector(
              onTap: onDelete,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.instance.error,
                  size: 22,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────
//  Add New Certification Card
// ──────────────────────────────────────────────

class AddCertificationCard extends StatelessWidget {
  final VoidCallback? onTap;

  const AddCertificationCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.instance.border, width: 1.2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.instance.boxBg,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add,
                color: AppColors.instance.primary,
                size: 22,
              ),
            ),
            const SizedBox(height: 8),
            CommonText(
              text: 'Add New Certification',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              textColor: AppColors.instance.secondaryText,
              isDescription: true,
              preventScaling: true,
            ),
          ],
        ),
      ),
    );
  }
}
