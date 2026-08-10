import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';

class SkillChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const SkillChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.instance.primary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? primary : Colors.transparent,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: isSelected ? primary : AppColors.instance.border,
            width: 1.5,
          ),
        ),
        child: CommonText(
          text: label,
          fontSize: 13,
          fontWeight: FontWeight.w500,
          textColor: isSelected
              ? AppColors.instance.white
              : AppColors.instance.textPrimary,
          isDescription: true,
          preventScaling: true,
        ),
      ),
    );
  }
}
