import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';

class HealthProfilePhotoPicker extends StatelessWidget {
  final VoidCallback onUploadTap;
  const HealthProfilePhotoPicker({super.key, required this.onUploadTap});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: colors.primary.withAlpha(10),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(Icons.person_add_outlined, size: 48, color: colors.primary.withAlpha(150)),
                ),
              ),
              Positioned(
                bottom: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colors.secondaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: colors.white, width: 3),
                  ),
                  child: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: onUploadTap,
            child: CommonText(
              text: 'Upload Photo',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              textColor: colors.secondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

class LanguageSelector extends StatelessWidget {
  final List<String> options;
  final String selected;
  final Function(String) onSelected;

  const LanguageSelector({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    return Row(
      children: options.map((opt) {
        final isSelected = selected == opt;
        return Padding(
          padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(
            onTap: () => onSelected(opt),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? colors.secondaryColor : colors.boxBg.withAlpha(30),
                borderRadius: BorderRadius.circular(12),
              ),
              child: CommonText(
                text: opt,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                textColor: isSelected ? colors.white : colors.secondaryText,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
