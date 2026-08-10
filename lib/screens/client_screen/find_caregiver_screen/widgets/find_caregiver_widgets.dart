import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:carely_caregiver/routes/app_routes.dart';
import 'package:carely_caregiver/screens/client_screen/find_caregiver_screen/controller/find_caregiver_controller.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CaregiverFilterRow extends StatelessWidget {
  final List<String> categories;
  final String selected;
  final ValueChanged<String> onSelected;

  const CaregiverFilterRow({
    super.key,
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories
            .map(
              (cat) => Padding(
                padding: const EdgeInsets.only(right: 10),
                child: _FilterChip(
                  label: cat,
                  isSelected: cat == selected,
                  onTap: () => onSelected(cat),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
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
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary : colors.boxBg.withAlpha(50),
          borderRadius: BorderRadius.circular(50),
        ),
        child: CommonText(
          text: label,
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          textColor: isSelected ? colors.white : colors.secondaryText,
        ),
      ),
    );
  }
}

class CaregiverCard extends StatelessWidget {
  final CaregiverModel caregiver;

  const CaregiverCard({super.key, required this.caregiver});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.instance.careGiverDetailsScreen);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(5),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Rounded Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: caregiver.avatarUrl.isNotEmpty
                      ? CommonImage(
                          src: caregiver.avatarUrl,
                          width: 80,
                          height: 80,
                          fill: BoxFit.cover,
                        )
                      : Container(
                          width: 80,
                          height: 80,
                          color: colors.boxBg,
                          child: Icon(Icons.person, color: colors.primary, size: 32),
                        ),
                ),
                const SizedBox(width: 16),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: CommonText(
                              text: '${caregiver.name}, ${caregiver.role}',
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              textColor: colors.textPrimary,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          _Rating(rating: caregiver.rating),
                        ],
                      ),
                      const SizedBox(height: 4),
                      CommonText(
                        text: caregiver.specialty,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        textColor: colors.secondaryColor,
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 6),
                      CommonText(
                        text: caregiver.description,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        textColor: colors.secondaryText,
                        textAlign: TextAlign.start,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      text: 'Starting at',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      textColor: colors.secondaryText,
                    ),
                    const SizedBox(height: 2),
                    CommonText(
                      text: '\$${caregiver.hourlyRate.toStringAsFixed(0)}/hr',
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      textColor: colors.primary,
                    ),
                  ],
                ),
                CommonButton(
                  buttonWidth: 120,
                  titleText: 'Book Now',
                  onTap: () {
                    Get.toNamed(AppRoutes.instance.careGiverDetailsScreen);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Rating extends StatelessWidget {
  final double rating;
  const _Rating({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
        const SizedBox(width: 4),
        CommonText(
          text: rating.toStringAsFixed(1),
          fontSize: 14,
          fontWeight: FontWeight.w600,
          textColor: AppColors.instance.textPrimary,
        ),
      ],
    );
  }
}

class EmptySearchState extends StatelessWidget {
  const EmptySearchState({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colors.boxBg.withAlpha(30),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.search_off_rounded, size: 50, color: colors.border),
            ),
            const SizedBox(height: 20),
            const CommonText(
              text: 'No caregivers found',
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(height: 8),
            CommonText(
              text: 'Try adjusting your filters or search terms.',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              textColor: colors.secondaryText,
            ),
          ],
        ),
      ),
    );
  }
}
