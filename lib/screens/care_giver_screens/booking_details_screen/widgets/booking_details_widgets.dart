import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:carely_caregiver/screens/care_giver_screens/booking_details_screen/controller/booking_details_controller.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';

class ClientProfileHeader extends StatelessWidget {
  final BookingDetails booking;
  const ClientProfileHeader({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;

    return Row(
      children: [
        Stack(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: colors.primary.withAlpha(50), width: 2),
              ),
              child: ClipOval(
                child: CommonImage(
                  src: booking.avatarUrl,
                  fill: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.white, width: 2),
                ),
                child: const Icon(Icons.check, size: 12, color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonText(
                text: booking.clientName,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                textColor: colors.textPrimary,
              ),
              const SizedBox(height: 4),
              CommonText(
                text: '${booking.recipientName} (${booking.relationship})',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                textColor: colors.primary,
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.amber, size: 18),
                  const SizedBox(width: 4),
                  CommonText(
                    text: 'Status: ${booking.status}',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    textColor: colors.secondaryText,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ScheduleEarningsCard extends StatelessWidget {
  final BookingDetails booking;
  const ScheduleEarningsCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.boxBg),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    text: 'SCHEDULE',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    textColor: colors.secondaryText,
                  ),
                  const SizedBox(height: 8),
                  CommonText(
                    text: booking.formattedDate,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    textColor: colors.textPrimary,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CommonText(
                    text: 'EARNINGS',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    textColor: colors.secondaryText,
                  ),
                  const SizedBox(height: 8),
                  CommonText(
                    text: '\$${booking.earnings.toStringAsFixed(2)}',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    textColor: colors.secondaryColor,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: CommonText(
              text: booking.timeRange,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              textColor: colors.secondaryText,
            ),
          ),
          const SizedBox(height: 16),
          Divider(color: colors.boxBg),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colors.primary.withAlpha(20),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.business_center_outlined, color: colors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      text: booking.serviceName,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      textColor: colors.textPrimary,
                    ),
                    CommonText(
                      text: 'Service ID: #${booking.id.substring(booking.id.length - 6).toUpperCase()}',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      textColor: colors.secondaryText,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AdditionalInstructionsCard extends StatelessWidget {
  final String instructions;
  const AdditionalInstructionsCard({super.key, required this.instructions});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CommonText(
          text: 'Additional Instructions',
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: colors.boxBg),
          ),
          child: Stack(
            children: [
              CommonText(
                text: instructions.isEmpty ? 'No instructions provided.' : instructions,
                fontSize: 15,
                fontWeight: FontWeight.w400,
                textColor: colors.textPrimary,
                textAlign: TextAlign.start,
              ),
              Positioned(
                bottom: -10,
                right: -10,
                child: Icon(Icons.format_quote_rounded, color: colors.boxBg, size: 40),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BookingDetailActions extends StatelessWidget {
  final bool isLoading;
  final String status;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const BookingDetailActions({
    super.key,
    required this.isLoading,
    required this.status,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    if (status != 'PENDING') return const SizedBox.shrink();

    final colors = AppColors.instance;

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: CommonButton(
            titleText: 'Accept Request',
            buttonColor: colors.secondaryColor,
            titleColor: colors.white,
            isLoading: isLoading,
            onTap: isLoading ? null : onAccept,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: CommonButton(
            titleText: 'Decline',
            buttonColor: colors.boxBg,
            titleColor: colors.textPrimary,
            onTap: isLoading ? null : onDecline,
          ),
        ),
      ],
    );
  }
}
