import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/cupertino.dart';

class SettingsToggleTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingsToggleTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colors.secondaryColor.withAlpha(20),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 22, color: colors.secondaryColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: CommonText(
              text: title,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              textColor: colors.textPrimary,
              textAlign: TextAlign.start,
            ),
          ),
          CupertinoSwitch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: colors.primary,
          ),
        ],
      ),
    );
  }
}
