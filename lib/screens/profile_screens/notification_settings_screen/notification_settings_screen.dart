import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:carely_caregiver/screens/profile_screens/notification_settings_screen/controller/notification_settings_controller.dart';
import 'package:carely_caregiver/screens/profile_screens/notification_settings_screen/widgets/notification_settings_widgets.dart';
import 'package:carely_caregiver/widgets/default_background_template.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationSettingsScreen extends GetView<NotificationSettingsController> {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;

    return DefaultBackgroundTemplate(
      appBarTitle: 'Profile',
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonText(
              text: 'General Preferences',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              textColor: colors.secondaryText.withAlpha(180),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(5),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Obx(
                () => Column(
                  children: [
                    SettingsToggleTile(
                      icon: Icons.notifications_none_rounded,
                      title: 'Enable Notifications',
                      value: controller.enableNotifications.value,
                      onChanged: controller.toggleEnableNotifications,
                    ),
                    _Divider(),
                    SettingsToggleTile(
                      icon: Icons.calendar_today_outlined,
                      title: 'Booking Alerts',
                      value: controller.bookingAlerts.value,
                      onChanged: controller.toggleBookingAlerts,
                    ),
                    _Divider(),
                    SettingsToggleTile(
                      icon: Icons.payments_outlined,
                      title: 'Payment Alerts',
                      value: controller.paymentAlerts.value,
                      onChanged: controller.togglePaymentAlerts,
                    ),
                    _Divider(),
                    SettingsToggleTile(
                      icon: Icons.chat_bubble_outline_rounded,
                      title: 'Messages',
                      value: controller.messages.value,
                      onChanged: controller.toggleMessages,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      indent: 68,
      color: AppColors.instance.boxBg.withAlpha(100),
    );
  }
}
