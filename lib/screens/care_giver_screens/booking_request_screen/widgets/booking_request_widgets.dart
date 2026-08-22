import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:carely_caregiver/screens/care_giver_screens/booking_request_screen/controller/booking_request_controller.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';

class BookingTabSelector extends StatelessWidget {
  final int selected;
  final int newCount;
  final Function(int) onTap;

  const BookingTabSelector({
    super.key,
    required this.selected,
    required this.newCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TabItem(
          label: 'New ($newCount)',
          isSelected: selected == 0,
          onTap: () => onTap(0),
        ),
        const SizedBox(width: 12),
        _TabItem(
          label: 'History',
          isSelected: selected == 1,
          onTap: () => onTap(1),
        ),
      ],
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? colors.secondaryColor : colors.boxBg,
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

class BookingRequestCard extends StatelessWidget {
  final BookingRequest request;
  final bool isNew;
  final VoidCallback onTap;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const BookingRequestCard({
    super.key,
    required this.request,
    required this.isNew,
    required this.onTap,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(8),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Client & Price Header
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CommonImage(
                    src: request.clientAvatar,
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
                        text: request.clientName,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        textColor: colors.textPrimary,
                      ),
                      const SizedBox(height: 2),
                      CommonText(
                        text: 'Client',
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        textColor: colors.secondaryText,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CommonText(
                      text: '\$${request.totalAmount.toStringAsFixed(2)}',
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      textColor: colors.secondaryColor,
                    ),
                    CommonText(
                      text: 'Total Amount',
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      textColor: colors.secondaryText,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Recipient & Service Details
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.boxBg.withAlpha(30),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _DetailRow(
                    label: 'Service:',
                    value: request.serviceName,
                    icon: Icons.medical_services_rounded,
                  ),
                  const SizedBox(height: 8),
                  _DetailRow(
                    label: 'For:',
                    value: '${request.recipientName} (${request.relationship})',
                    icon: Icons.person_rounded,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Time & Date
            _DetailItem(
              icon: Icons.calendar_today_rounded,
              text: request.formattedDateTime,
            ),
            
            if (isNew) ...[
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: CommonButton(
                      titleText: 'Decline',
                      buttonColor: const Color(0xffF5F6FA),
                      titleColor: colors.textPrimary,
                      buttonHeight: 48,
                      buttonRadius: 12,
                      onTap: onDecline,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CommonButton(
                      titleText: 'Accept Request',
                      buttonColor: colors.secondaryColor,
                      titleColor: colors.white,
                      buttonHeight: 48,
                      buttonRadius: 12,
                      onTap: onAccept,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _DetailRow({required this.label, required this.value, required this.icon});

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
          fontWeight: FontWeight.w500,
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

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _DetailItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    return Row(
      children: [
        Icon(icon, size: 18, color: colors.primary),
        const SizedBox(width: 10),
        Expanded(
          child: CommonText(
            text: text,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            textColor: colors.textPrimary,
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }
}
