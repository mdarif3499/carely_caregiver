import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:carely_caregiver/routes/app_routes.dart';
import 'package:carely_caregiver/widgets/default_background_template.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingStatusScreen extends StatelessWidget {
  const BookingStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;

    return DefaultBackgroundTemplate(
      appBarTitle: 'Booking Status',
      hideBackButton: true,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            // Success Icon
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: colors.primary.withAlpha(15),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: colors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: colors.primary.withAlpha(50),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.business_center_outlined, color: Colors.white, size: 48),
                ),
              ),
            ),
            const SizedBox(height: 40),
            const CommonText(
              text: 'Booking Request Sent!',
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(height: 12),
            CommonText(
              text: 'Your request has been sent to Sarah Jenkins. You will be notified once she accepts.',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              textColor: colors.secondaryText,
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            // Action Buttons
            CommonButton(
              titleText: 'Message Caregiver',
              onTap: () {
                Get.toNamed(AppRoutes.instance.messageScreen);
              },
              buttonWidth: double.infinity,
            ),
            const SizedBox(height: 16),
            CommonButton(
              titleText: 'Go Back to Home Page',
              buttonColor: colors.boxBg,
              titleColor: colors.textPrimary,
              onTap: () {
                Get.offAllNamed(AppRoutes.instance.appNavigationScreen);
              },
              buttonWidth: double.infinity,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
