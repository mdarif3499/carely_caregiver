import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:carely_caregiver/screens/client_screen/controller/client_home_controller.dart';
import 'package:carely_caregiver/screens/client_screen/widgets/client_home_widgets.dart';
import 'package:carely_caregiver/widgets/default_background_template.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app_navigation_screen/controller/app_navigation_screen_controller.dart';

class ClientHomeScreen extends StatelessWidget {
  const ClientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClientHomeController>();
    final navC = Get.find<AppNavigationScreenController>();
    final colors = AppColors.instance;

    return DefaultBackgroundTemplate(
      titleWidget: Obx(
        () => ClientHomeHeader(
          userName: navC.userModel.value?.name ?? "...",
          avatarUrl: navC.userModel.value?.profileImage ?? "",
          onFilterTap: controller.onFilterTap,
          onNotificationTap: controller.onNotificationTap,
        ),
      ),
      hideBackButton: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Search Bar ──
            ClientSearchBar(onChanged: controller.onSearchChanged),
            const SizedBox(height: 24),

            // ── Hero Banner ──
            ProfessionalCareBanner(onTap: controller.onLearnMore),
            const SizedBox(height: 32),

            // ── Upcoming Booking ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonText(
                  text: 'Upcoming Booking',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  textColor: colors.textPrimary,
                ),
                GestureDetector(
                  onTap: controller.onSeeAllBookings,
                  child: CommonText(
                    text: 'See All',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    textColor: colors.secondaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(
              () => ClientUpcomingBookingCard(
                booking: controller.upcomingBooking.value,
                onViewDetails: controller.onViewDetails,
                onChat: () {},
              ),
            ),
            const SizedBox(height: 32),

            // ── Recent Activity ──
            const CommonText(
              text: 'Recent Activity',
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colors.white,
                borderRadius: BorderRadius.circular(24),
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
                  children: List.generate(controller.recentActivities.length, (index) {
                    final activity = controller.recentActivities[index];
                    final isLast = index == controller.recentActivities.length - 1;
                    return Column(
                      children: [
                        ClientActivityItem(activity: activity),
                        if (!isLast)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Divider(color: colors.boxBg, height: 1),
                          ),
                      ],
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
