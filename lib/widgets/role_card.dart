import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:carely_caregiver/widgets/text/primary_text.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';

class RoleCard extends StatelessWidget {
  const RoleCard({
    super.key,
    required this.iconImage,
    required this.title,
    required this.description,
    this.isSelected = false,
    this.onTap,
    this.iconBackgroundColor,
    this.iconColor,
    this.selectedBorderColor,
  });

  final String iconImage;
  final String title;
  final String description;
  final bool isSelected;
  final VoidCallback? onTap;
  final Color? iconBackgroundColor;
  final Color? iconColor;
  final Color? selectedBorderColor;

  @override
  Widget build(BuildContext context) {
    final bgIconColor =
        iconBackgroundColor ?? AppColors.instance.primary.withAlpha(30);

    final borderColor =
        selectedBorderColor ?? AppColors.instance.primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? borderColor : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            // Icon container
            Container(
              padding: const EdgeInsets.symmetric(vertical: 32),
              decoration: BoxDecoration(
                color: AppColors.instance.boxBg.withAlpha(30),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              width: double.infinity,
              child: Container(
                height: 120.h,
                width: 120.h,
                decoration: BoxDecoration(
                  color: bgIconColor,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(36.0),
                  child: CommonImage(
                    src: iconImage,
                    height: 48,
                    width: 48,
                    fill: BoxFit.contain,
                  ),
                ),
              ),
            ),

            // Text container
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppContentHeader(
                    text: title,
                    fontSize: 22,
                  ),
                  4.height,
                  AppSecondaryText(
                    text: description,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
