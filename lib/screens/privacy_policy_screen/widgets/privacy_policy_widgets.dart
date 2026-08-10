import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';

class LastUpdatedBanner extends StatelessWidget {
  final String date;
  const LastUpdatedBanner({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.secondaryColor.withAlpha(20),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.secondaryColor.withAlpha(50)),
      ),
      child: Row(
        children: [
          Icon(Icons.access_time_rounded, color: colors.secondaryColor, size: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonText(
                text: 'Last Updated',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                textColor: colors.secondaryColor,
              ),
              CommonText(
                text: date,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                textColor: colors.textPrimary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PolicySectionHeader extends StatelessWidget {
  final String title;
  const PolicySectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: colors.secondaryColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        CommonText(
          text: title,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          textColor: colors.textPrimary,
        ),
      ],
    );
  }
}

class BulletPointItem extends StatelessWidget {
  final String title;
  final String description;
  const BulletPointItem({super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Icon(Icons.circle, size: 6, color: colors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  text: title,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  textColor: colors.textPrimary,
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 4),
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
        ],
      ),
    );
  }
}

class CheckmarkItem extends StatelessWidget {
  final String text;
  const CheckmarkItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: colors.primary.withAlpha(20),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check, size: 12, color: colors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: CommonText(
              text: text,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              textColor: colors.textPrimary,
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}

class SecurityBox extends StatelessWidget {
  final String text;
  const SecurityBox({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2C3E50),
        borderRadius: BorderRadius.circular(20),
      ),
      child: CommonText(
        text: text,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        textColor: Colors.white.withAlpha(230),
        textAlign: TextAlign.start,
        height: 1.5,
      ),
    );
  }
}
