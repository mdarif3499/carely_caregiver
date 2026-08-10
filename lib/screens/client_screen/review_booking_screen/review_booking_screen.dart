import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:carely_caregiver/screens/client_screen/book_caregiver_screen/widgets/book_caregiver_widgets.dart';
import 'package:carely_caregiver/screens/client_screen/book_caregiver_screen/controller/book_caregiver_controller.dart';
import 'package:carely_caregiver/screens/client_screen/review_booking_screen/widgets/review_booking_widgets.dart';
import 'package:carely_caregiver/widgets/default_background_template.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../gen/assets.gen.dart';
import '../../../routes/app_routes.dart';

class ReviewBookingScreen extends StatelessWidget {
  const ReviewBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final BookCaregiverController controller =
        Get.find<BookCaregiverController>();
    final colors = AppColors.instance;

    return DefaultBackgroundTemplate(
      appBarTitle: 'Review Booking',
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CaregiverInfoCard(isHoursShow: false),
                  const SizedBox(height: 24),
                  const CommonText(
                    text: 'Booking Details',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                  const SizedBox(height: 16),
                  BookingDetailRow(
                    icon: Assets.icons.medicale,
                    label: 'SERVICE',
                    value: 'Companion Care',
                    onEdit: () => Get.back(),
                  ),
                  const SizedBox(height: 12),
                  Obx(
                    () => BookingDetailRow(
                      icon: Assets.icons.calender,
                      label: 'DATE & TIME',
                      value: controller.selectedScheduleText,
                      onEdit: () => Get.back(),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const EstimatedCostCard(),
                  const SizedBox(height: 32),
                  const InstructionsField(),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            decoration: BoxDecoration(
              color: colors.white,
              border: Border(top: BorderSide(color: colors.boxBg)),
            ),
            child: Column(
              children: [
                CommonButton(
                  titleText: 'Send Booking Request',
                  onTap: () {
                    Get.toNamed(AppRoutes.instance.bookingStatusScreen);
                  },
                  buttonWidth: double.infinity,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock_outline_rounded, size: 12, color: colors.secondaryText),
                    const SizedBox(width: 4),
                    CommonText(
                      text: 'SECURE SSL ENCRYPTED TRANSACTION',
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      textColor: colors.secondaryText,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
