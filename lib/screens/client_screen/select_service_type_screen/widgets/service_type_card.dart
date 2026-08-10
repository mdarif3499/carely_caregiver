import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';

class ServiceTypeCard extends StatelessWidget {
  final String title;
  final String description;
  final String icon;
  final bool isSelected;
  final VoidCallback onTap;

  const ServiceTypeCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary.withAlpha(10) : colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? colors.primary : colors.boxBg,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: colors.primary.withAlpha(20),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colors.secondaryColor.withAlpha(20),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CommonImage(src: icon, height: 32, width: 32),
                ),
                _CustomRadioButton(isSelected: isSelected),
              ],
            ),
            const SizedBox(height: 20),
            CommonText(
              text: title,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              textColor: colors.textPrimary,
            ),
            const SizedBox(height: 8),
            CommonText(
              text: description,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              textColor: colors.secondaryText,
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomRadioButton extends StatelessWidget {
  final bool isSelected;
  const _CustomRadioButton({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? colors.primary : colors.border,
          width: 2,
        ),
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.primary,
                ),
              ),
            )
          : null,
    );
  }
}
