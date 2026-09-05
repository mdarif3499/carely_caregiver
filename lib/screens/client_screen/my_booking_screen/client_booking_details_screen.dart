import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:carely_caregiver/screens/client_screen/my_booking_screen/controller/client_booking_details_controller.dart';
import 'package:carely_caregiver/widgets/default_background_template.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';


class ClientBookingDetailsScreen extends StatelessWidget {
  const ClientBookingDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ClientBookingDetailsController());
    final colors = AppColors.instance;

    return DefaultBackgroundTemplate(
      appBarTitle: 'Booking Details',
      child: Obx(() {
        final b = c.booking.value;
        
        return Skeletonizer(
          enabled: c.isLoading.value,
          child: b == null && !c.isLoading.value
              ? const Center(child: CommonText(text: "Booking not found"))
              : Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(20.r),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ── Caregiver Header ──
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 40.r,
                                  backgroundColor: colors.boxBg,
                                  backgroundImage: (b?.caregiverAvatar ?? "").isNotEmpty ? NetworkImage(b!.caregiverAvatar) : null,
                                  child: (b?.caregiverAvatar ?? "").isEmpty ? Icon(Icons.person, color: colors.primary, size: 40.sp) : null,
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CommonText(
                                        text: b?.caregiverName ?? '...',
                                        fontSize: 22.sp,
                                        fontWeight: FontWeight.w700,
                                        textColor: colors.textPrimary,
                                      ),
                                      SizedBox(height: 4.h),
                                      Row(
                                        children: [
                                          Icon(Icons.star_rounded, color: Colors.amber, size: 20.sp),
                                          SizedBox(width: 4.w),
                                          CommonText(
                                            text: "4.9 (120 reviews)", // Fallback if rating not in model
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                            textColor: colors.secondaryText,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 4.h),
                                      Row(
                                        children: [
                                          Icon(Icons.location_on_outlined, size: 16.sp, color: colors.secondaryText),
                                          SizedBox(width: 4.w),
                                          CommonText(
                                            text: "New York, NY", // Fallback
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                            textColor: colors.secondaryText,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 32.h),

                            // ── Schedule & Price Card ──
                            Container(
                              padding: EdgeInsets.all(20.r),
                              decoration: BoxDecoration(
                                color: colors.white,
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(color: colors.boxBg),
                                boxShadow: [BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 10.r, offset: Offset(0, 4.h))],
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      CommonText(
                                        text: 'SCHEDULE',
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        textColor: const Color(0xff7F8C8D),
                                      ),
                                      CommonText(
                                        text: 'TOTAL PAID',
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        textColor: const Color(0xff7F8C8D),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      CommonText(
                                        text: _formatDate(b?.date ?? ""),
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w700,
                                        textColor: colors.textPrimary,
                                      ),
                                      CommonText(
                                        text: '\$${(b?.amount ?? 0.0).toStringAsFixed(2)}',
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w700,
                                        textColor: colors.secondaryColor,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.h),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: CommonText(
                                      text: b?.formattedTimeRange ?? '...',
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      textColor: colors.secondaryText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 24.h),

                            // ── Care Details ──
                            CommonText(
                              text: 'Care Details',
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                            ),
                            SizedBox(height: 16.h),
                            _DetailRow(
                              icon: Icons.medical_services_outlined,
                              label: 'Service:',
                              value: b?.serviceName ?? '...',
                            ),
                            SizedBox(height: 12.h),
                            _DetailRow(
                              icon: Icons.person_outline_rounded,
                              label: 'For:',
                              value: b != null ? '${b.recipientName} (${b.relationship})' : '...',
                            ),
                            SizedBox(height: 12.h),
                            _DetailRow(
                              icon: Icons.info_outline_rounded,
                              label: 'Status:',
                              value: b?.formattedStatus ?? '...',
                              isStatus: true,
                            ),
                            SizedBox(height: 12.h),
                            _DetailRow(
                              icon: Icons.payments_outlined,
                              label: 'Payment:',
                              value: b?.formattedPaymentStatus ?? '...',
                              isStatus: true,
                            ),
                            SizedBox(height: 32.h),

                            // ── Instructions ──
                            if ((b?.instructions ?? "").isNotEmpty) ...[
                              CommonText(
                                text: 'Additional Instructions',
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                              ),
                              SizedBox(height: 12.h),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(16.r),
                                decoration: BoxDecoration(
                                  color: colors.boxBg.withAlpha(30),
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                                child: CommonText(
                                  text: b?.instructions ?? "",
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w400,
                                  textColor: colors.textPrimary,
                                  textAlign: TextAlign.start,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),

                    // ── Chat Button ──
                    if ((b?.paymentStatus ?? "").toUpperCase() != 'UNPAID')
                      Padding(
                        padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 30.h),
                        child: CommonButton(
                          titleText: 'Chat with Caregiver',
                          onTap: c.onChat,
                          prefix: Icon(Icons.chat_bubble_outline_rounded, color: Colors.white, size: 20.sp),
                          buttonWidth: double.infinity,
                          buttonHeight: 56.h,
                          buttonRadius: 16.r,
                        ),
                      ),
                  ],
                ),
        );
      }),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final dt = DateTime.parse(dateStr);
      return DateFormat('EEEE, MMM d').format(dt);
    } catch (_) {
      return dateStr;
    }
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isStatus;

  const _DetailRow({required this.icon, required this.label, required this.value, this.isStatus = false});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    return Row(
      children: [
        Icon(icon, size: 20.sp, color: colors.primary),
        SizedBox(width: 12.w),
        CommonText(
          text: label,
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
          textColor: colors.secondaryText,
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: CommonText(
            text: value,
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            textColor: isStatus ? colors.primary : colors.textPrimary,
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }
}
