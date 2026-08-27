import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:carely_caregiver/screens/client_screen/controller/client_home_controller.dart';
import 'package:carely_caregiver/screens/client_screen/widgets/client_home_widgets.dart';
import 'package:carely_caregiver/widgets/default_background_template.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

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

            ///

            SizedBox(height: 16.h),
            Obx(
              () => Skeletonizer(
                enabled: controller.isBookingsLoading.value,
                child: controller.upcomingBookings.isEmpty && !controller.isBookingsLoading.value
                    ? Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 32.h),
                        decoration: BoxDecoration(
                          color: colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(color: colors.boxBg),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.calendar_today_outlined, size: 40.sp, color: Colors.grey.shade300),
                            SizedBox(height: 12.h),
                            CommonText(
                              text: 'No bookings for today.',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              textColor: Colors.grey,
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: controller.upcomingBookings.map((booking) {
                            return Padding(
                              padding: EdgeInsets.only(right: 16.w),
                              child: ClientUpcomingBookingCard(
                                booking: booking,
                                onViewDetails: () => controller.onViewDetails(booking.id),
                                onChat: () {},
                              ),
                            );
                          }).toList(),
                        ),
                      ),
              ),
            ),
            SizedBox(height: 32.h),

            // ── Recent Activity ──
            CommonText(
              text: 'Recent Activity',
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
            ),
            SizedBox(height: 20.h),
            Obx(
              () => Skeletonizer(
                enabled: controller.isBookingsLoading.value,
                child: Container(
                  padding: EdgeInsets.all(20.r),
                  decoration: BoxDecoration(
                    color: colors.white,
                    borderRadius: BorderRadius.circular(24.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(5),
                        blurRadius: 10.r,
                        offset: Offset(0, 4.h),
                      ),
                    ],
                  ),
                  child: Column(
                    children: List.generate(controller.recentActivities.length, (index) {
                      final activity = controller.recentActivities[index];
                      final isLast = index == controller.recentActivities.length - 1;
                      return Column(
                        children: [
                          ClientActivityItem(activity: activity),
                          if (!isLast)
                            Padding(
                              padding: EdgeInsets.only(bottom: 20.h),
                              child: Divider(color: colors.boxBg, height: 1.h),
                            ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}
