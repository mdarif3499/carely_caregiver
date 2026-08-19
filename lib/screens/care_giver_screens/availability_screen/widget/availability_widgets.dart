import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:carely_caregiver/screens/care_giver_screens/availability_screen/controller/availability_screen_controller.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';

class ShiftCard extends StatelessWidget {
  final Shift shift;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const ShiftCard({
    super.key,
    required this.shift,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colors.textGrey.withAlpha(20),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon Box
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: colors.boxBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Icon(
                _getIcon(),
                color: colors.primary,
                size: 28,
              ),
            ),
          ),
          12.width,

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  text: shift.label,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  textColor: colors.textPrimary,
                ),
                4.height,
                CommonText(
                  text: shift.timeRange,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  textColor: colors.secondaryText,
                ),
              ],
            ),
          ),

          // Actions
          Row(
            children: [
              IconButton(
                onPressed: onEdit,
                icon: Icon(Icons.edit_outlined, color: colors.secondaryColor, size: 22),
                visualDensity: VisualDensity.compact,
              ),
              IconButton(
                onPressed: onDelete,
                icon: Icon(Icons.delete_outline_rounded, color: colors.error, size: 22),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getIcon() {
    switch (shift.shiftType.toUpperCase()) {
      case 'MORNING':
        return Icons.wb_sunny_outlined;
      case 'AFTERNOON':
        return Icons.wb_twilight_rounded;
      case 'EVENING':
        return Icons.nightlight_outlined;
      default:
        return Icons.access_time_rounded;
    }
  }
}
