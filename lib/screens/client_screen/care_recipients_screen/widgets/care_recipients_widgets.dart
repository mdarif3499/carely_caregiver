import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';

class AddRecipientDashedCard extends StatelessWidget {
  final VoidCallback onTap;
  const AddRecipientDashedCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colors.primary.withAlpha(5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: colors.secondaryColor,
            width: 1.5,
            style: BorderStyle.solid, // Note: standard Flutter doesn't have native "dashed" border, 
            // but we can simulate it or use a custom painter if needed. 
            // For now, using a solid professional border in the brand color.
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colors.secondaryColor.withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person_add_outlined, color: colors.secondaryColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    text: 'Add New Recipient',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    textColor: colors.textPrimary,
                  ),
                  const SizedBox(height: 4),
                  CommonText(
                    text: 'Register a new family member',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    textColor: colors.secondaryText,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colors.secondaryColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}

class RecipientListCard extends StatelessWidget {
  final String name;
  final String relationship;
  final List<String> tags;
  final String imageUrl;
  final VoidCallback onTap;

  const RecipientListCard({
    super.key,
    required this.name,
    required this.relationship,
    required this.tags,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;

    return Container(
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
      child: InkWell(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Placeholder Image
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Container(
                width: 80,
                height: 100,
                color: colors.boxBg.withAlpha(50),
                child: const Icon(Icons.person, size: 40, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonText(
                        text: name,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        textColor: colors.textPrimary,
                      ),
                      Icon(Icons.chevron_right_rounded, color: colors.secondaryText),
                    ],
                  ),
                  CommonText(
                    text: relationship,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    textColor: colors.secondaryText,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: tags.map((tag) => ServiceTag(label: tag)).toList(),
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

class ServiceTag extends StatelessWidget {
  final String label;
  const ServiceTag({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    final isBlue = label.toLowerCase().contains('care');
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isBlue ? colors.secondaryColor.withAlpha(15) : colors.boxBg.withAlpha(50),
        borderRadius: BorderRadius.circular(50),
      ),
      child: CommonText(
        text: label,
        fontSize: 10,
        fontWeight: FontWeight.w600,
        textColor: isBlue ? colors.secondaryColor : colors.secondaryText,
      ),
    );
  }
}
