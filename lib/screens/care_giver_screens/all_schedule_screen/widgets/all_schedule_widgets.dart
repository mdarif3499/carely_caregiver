import 'package:carely_caregiver/app_all_enum/app_login_status.dart';
import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:carely_caregiver/screens/care_giver_screens/all_schedule_screen/model/care_giver_schedule_model.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';

class ScheduleDetailCard extends StatelessWidget {
  final CareGiverScheduleModel item;
  const ScheduleDetailCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    final isCaregiver = selectedAppUserType == AppUserType.caregiver;

    final displayName = isCaregiver ? item.clientName : item.caregiverName;
    final displayAvatar = isCaregiver ? item.clientAvatar : item.caregiverAvatar;
    final displayRole = isCaregiver ? 'Client' : 'Caregiver';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CommonImage(
                  src: displayAvatar,
                  height: 50,
                  width: 50,
                  fill: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      text: displayName,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      textColor: colors.textPrimary,
                    ),
                    CommonText(
                      text: displayRole,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      textColor: colors.secondaryText,
                    ),
                  ],
                ),
              ),
              _StatusBadge(status: item.status),
            ],
          ),
          const SizedBox(height: 16),
          Divider(height: 1, color: colors.boxBg),
          const SizedBox(height: 16),
          _InfoRow(
            icon: Icons.person_outline_rounded,
            label: 'Recipient:',
            value: '${item.recipientName} (${item.relationship})',
          ),
          const SizedBox(height: 8),
          _InfoRow(
            icon: Icons.medical_services_outlined,
            label: 'Service:',
            value: item.serviceName,
          ),
          const SizedBox(height: 8),
          _InfoRow(
            icon: Icons.access_time_rounded,
            label: 'Time:',
            value: item.formattedTimeRange,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CommonText(
                text: 'Expected Earnings:',
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              CommonText(
                text: '\$${item.amount.toStringAsFixed(2)}',
                fontSize: 18,
                fontWeight: FontWeight.w800,
                textColor: colors.secondaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    return Row(
      children: [
        Icon(icon, size: 16, color: colors.primary),
        const SizedBox(width: 8),
        CommonText(
          text: label,
          fontSize: 13,
          fontWeight: FontWeight.w400,
          textColor: colors.secondaryText,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: CommonText(
            text: value,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            textColor: colors.textPrimary,
            textAlign: TextAlign.start,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;

    switch (status.toUpperCase()) {
      case 'PENDING':
        bgColor = Colors.orange.withAlpha(20);
        textColor = Colors.orange;
        break;
      case 'ACCEPTED':
        bgColor = Colors.green.withAlpha(20);
        textColor = Colors.green;
        break;
      case 'AUTO_RELEASED':
        bgColor = Colors.red.withAlpha(20);
        textColor = Colors.red;
        break;
      default:
        bgColor = Colors.grey.withAlpha(20);
        textColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(50),
      ),
      child: CommonText(
        text: status.replaceAll('_', ' '),
        fontSize: 10,
        fontWeight: FontWeight.w700,
        textColor: textColor,
      ),
    );
  }
}
