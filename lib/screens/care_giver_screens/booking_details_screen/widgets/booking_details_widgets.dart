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
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: colors.primary.withAlpha(50), width: 2.w),
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
                padding: EdgeInsets.all(4.r),
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.white, width: 2.w),
                ),
                child: Icon(Icons.check, size: 12.sp, color: Colors.white),
              ),
            ),
          ],
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonText(
                text: booking.clientName,
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                textColor: colors.textPrimary,
              ),
              SizedBox(height: 4.h),
              CommonText(
                text: '${booking.recipientName} (${booking.relationship})',
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                textColor: colors.primary,
              ),
              SizedBox(height: 10.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _StatusItem(
                    icon: Icons.info_outline,
                    label: 'Status:',
                    value: booking.formattedStatus,
                    valueColor: Colors.amber,
                  ),
                  SizedBox(height: 6.h),
                  _StatusItem(
                    icon: Icons.payments_outlined,
                    label: 'Payment:',
                    value: booking.formattedPaymentStatus,
                    valueColor: Colors.blue,
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

class _StatusItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;

  const _StatusItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: colors.secondaryText, size: 16.sp),
        SizedBox(width: 4.w),
        CommonText(
          text: '$label ',
          fontSize: 13.sp,
          fontWeight: FontWeight.w400,
          textColor: colors.secondaryText,
        ),
        CommonText(
          text: value,
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          textColor: valueColor,
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
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: colors.white,
        borderRadius: BorderRadius.circular(16.r),
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
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    textColor: colors.secondaryText,
                  ),
                  SizedBox(height: 8.h),
                  CommonText(
                    text: booking.formattedDate,
                    fontSize: 18.sp,
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
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    textColor: colors.secondaryText,
                  ),
                  SizedBox(height: 8.h),
                  CommonText(
                    text: '\$${booking.earnings.toStringAsFixed(2)}',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    textColor: colors.secondaryColor,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Align(
            alignment: Alignment.centerLeft,
            child: CommonText(
              text: booking.timeRange,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              textColor: colors.secondaryText,
            ),
          ),
          SizedBox(height: 16.h),
          Divider(color: colors.boxBg),
          SizedBox(height: 16.h),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: colors.primary.withAlpha(20),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(Icons.business_center_outlined, color: colors.primary, size: 20.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      text: booking.serviceName,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      textColor: colors.textPrimary,
                    ),
                    CommonText(
                      text: 'Service ID: #${booking.id.length > 6 ? booking.id.substring(booking.id.length - 6).toUpperCase() : booking.id}',
                      fontSize: 12.sp,
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
        CommonText(
          text: 'Additional Instructions',
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
        ),
        SizedBox(height: 12.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: colors.white,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(color: colors.boxBg),
          ),
          child: Stack(
            children: [
              CommonText(
                text: instructions.isEmpty ? 'No instructions provided.' : instructions,
                fontSize: 15.sp,
                fontWeight: FontWeight.w400,
                textColor: colors.textPrimary,
                textAlign: TextAlign.start,
              ),
              Positioned(
                bottom: -10.h,
                right: -10.w,
                child: Icon(Icons.format_quote_rounded, color: colors.boxBg, size: 40.sp),
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
  final BookingDetails booking;
  final VoidCallback onAccept;
  final VoidCallback onDecline;
  final VoidCallback onComplete;

  const BookingDetailActions({
    super.key,
    required this.isLoading,
    required this.booking,
    required this.onAccept,
    required this.onDecline,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    final status = booking.status;

    if (status == 'PENDING') {
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
          SizedBox(height: 12.h),
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

    if (status == 'CONFIRMED') {
      final canComplete = booking.canBeCompleted;
      
      return SizedBox(
        width: double.infinity,
        child: CommonButton(
          titleText: 'Complete Booking',
          buttonColor: canComplete ? colors.secondaryColor : colors.secondaryColor.withAlpha(100),
          titleColor: colors.white,
          isLoading: isLoading,
          onTap: (isLoading || !canComplete) ? null : onComplete,
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
