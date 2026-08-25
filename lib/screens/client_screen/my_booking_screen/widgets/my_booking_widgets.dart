import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:carely_caregiver/screens/care_giver_screens/all_schedule_screen/model/care_giver_schedule_model.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClientBookingCard extends StatelessWidget {
  final CareGiverScheduleModel booking;
  final VoidCallback onTap;

  const ClientBookingCard({super.key, required this.booking, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;

    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                    src: booking.caregiverAvatar,
                    height: 52,
                    width: 52,
                    fill: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText(
                        text: booking.caregiverName,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        textColor: colors.textPrimary,
                        textAlign: TextAlign.start,
                      ),
                      CommonText(
                        text: 'Caregiver',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        textColor: colors.secondaryText,
                      ),
                    ],
                  ),
                ),
                _StatusBadge(status: booking.status),
              ],
            ),
            const SizedBox(height: 16),
            Divider(height: 1, color: colors.boxBg),
            const SizedBox(height: 16),
            _InfoRow(
              icon: Icons.medical_services_outlined,
              label: 'Service:',
              value: booking.serviceName,
            ),
            const SizedBox(height: 8),
            _InfoRow(
              icon: Icons.person_outline_rounded,
              label: 'For:',
              value: booking.recipientName,
            ),
            const SizedBox(height: 8),
            _InfoRow(
              icon: Icons.access_time_rounded,
              label: 'Time:',
              value: '${_formatDate(booking.date)}, ${booking.formattedTimeRange}',
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CommonText(
                  text: 'Total Amount Paid:',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                CommonText(
                  text: '\$${booking.amount.toStringAsFixed(2)}',
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  textColor: colors.secondaryColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final dt = DateTime.parse(dateStr);
      return DateFormat('MMM d, yyyy').format(dt);
    } catch (_) {
      return dateStr;
    }
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
      case 'CONFIRMED':
        bgColor = Colors.green.withAlpha(20);
        textColor = Colors.green;
        break;
      case 'AUTO_RELEASED':
      case 'DECLINED':
      case 'CANCELLED':
        bgColor = Colors.red.withAlpha(20);
        textColor = Colors.red;
        break;
      case 'COMPLETED':
        bgColor = Colors.blue.withAlpha(20);
        textColor = Colors.blue;
        break;
      default:
        bgColor = Colors.grey.withAlpha(20);
        textColor = Colors.grey;
    }

    String label = status.split('_').map((word) {
      if (word.isEmpty) return "";
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(50),
      ),
      child: CommonText(
        text: label,
        fontSize: 10,
        fontWeight: FontWeight.w700,
        textColor: textColor,
      ),
    );
  }
}
