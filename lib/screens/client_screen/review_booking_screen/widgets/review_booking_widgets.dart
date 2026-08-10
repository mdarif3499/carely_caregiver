import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';

class BookingDetailRow extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  final VoidCallback onEdit;

  const BookingDetailRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.boxBg),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colors.primary.withAlpha(15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: CommonImage(src: icon, height: 20, width: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  text: label,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  textColor: colors.secondaryText,
                ),
                const SizedBox(height: 2),
                CommonText(
                  text: value,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  textColor: colors.textPrimary,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onEdit,
            child: CommonText(
              text: 'Edit',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              textColor: colors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class EstimatedCostCard extends StatelessWidget {
  const EstimatedCostCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.boxBg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(
            text: 'ESTIMATED COST',
            fontSize: 12,
            fontWeight: FontWeight.w700,
            textColor: colors.secondaryText,
          ),
          const SizedBox(height: 16),
          _CostRow(label: 'BASE RATE', value: '\$140.00'),
          const SizedBox(height: 12),
          _CostRow(label: 'Service Fee', value: '\$12.50'),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonText(
                text: 'Total Estimated',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                textColor: colors.textPrimary,
              ),
              CommonText(
                text: '\$152.50',
                fontSize: 18,
                fontWeight: FontWeight.w800,
                textColor: colors.primary,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.secondaryColor.withAlpha(10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded, size: 18, color: colors.secondaryColor),
                const SizedBox(width: 8),
                Expanded(
                  child: CommonText(
                    text: 'You won\'t be charged until Sarah accepts your booking request.',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    textColor: colors.textPrimary,
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CostRow extends StatelessWidget {
  final String label;
  final String value;
  const _CostRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CommonText(
          text: label,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          textColor: colors.textPrimary,
        ),
        CommonText(
          text: value,
          fontSize: 15,
          fontWeight: FontWeight.w600,
          textColor: colors.textPrimary,
        ),
      ],
    );
  }
}

class InstructionsField extends StatelessWidget {
  const InstructionsField({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CommonText(
          text: 'Additional Instructions',
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        const SizedBox(height: 12),
        TextField(
          maxLines: 4,
          style: TextStyle(fontSize: 14, color: colors.textPrimary),
          decoration: InputDecoration(
            hintText: 'e.g., Please enter through the side door, the doorbell is loud ...',
            hintStyle: TextStyle(fontSize: 13, color: colors.secondaryText),
            filled: true,
            fillColor: colors.white,
            contentPadding: const EdgeInsets.all(16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: colors.boxBg),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: colors.boxBg),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: colors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
