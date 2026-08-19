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
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Client Info
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CommonImage(
                    src: request.avatarUrl,
                    height: 60,
                    width: 60,
                    fill: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText(
                        text: '${request.clientName}, ${request.clientRole}',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        textColor: colors.textPrimary,
                      ),
                      const SizedBox(height: 4),
                      CommonText(
                        text: '${request.previousJobs} Previous Jobs',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        textColor: colors.primary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Details
            _DetailItem(
              icon: Icons.medical_services_outlined,
              text: request.serviceType,
            ),
            const SizedBox(height: 12),
            _DetailItem(
              icon: Icons.calendar_today_outlined,
              text: '${request.dateTime} (${request.duration})',
            ),
            const SizedBox(height: 12),
            _DetailItem(
              icon: Icons.location_on_outlined,
              text: '${request.location} . ${request.distanceMiles} miles away',
            ),
            
            if (isNew) ...[
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: CommonButton(
                      titleText: 'Decline',
                      buttonColor: colors.boxBg,
                      titleColor: colors.textPrimary,
                      onTap: onDecline,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CommonButton(
                      titleText: 'Accept Request',
                      buttonColor: colors.secondaryColor,
                      titleColor: colors.white,
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

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _DetailItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    return Row(
      children: [
        Icon(icon, size: 20, color: colors.primary),
        const SizedBox(width: 10),
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
    );
  }
}
