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
            const ProfessionalCareBanner(),
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

            // ── Service Categories ──
            CommonText(
              text: 'Service Categories',
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
            ),
            SizedBox(height: 20.h),
            Obx(
              () => Skeletonizer(
                enabled: controller.isCategoriesLoading.value,
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16.w,
                    mainAxisSpacing: 16.h,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: controller.isCategoriesLoading.value ? 6 : controller.categories.length,
                  itemBuilder: (context, index) {
                    if (controller.isCategoriesLoading.value) {
                      return ServiceCategoryItem(
                        title: '...',
                        icon: Icons.category_outlined,
                        onTap: () {},
                      );
                    }
                    final category = controller.categories[index];
                    return ServiceCategoryItem(
                      title: category.name,
                      icon: _getCategoryIcon(category.name),
                      onTap: () => controller.onCategoryTap(category),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String name) {
    switch (name.toLowerCase()) {
      case 'memory care':
        return Icons.psychology_outlined;
      case 'daily living':
        return Icons.home_work_outlined;
      case 'elderly care':
        return Icons.elderly_outlined;
      case 'post-surgical':
        return Icons.healing_outlined;
      case 'dementia care':
        return Icons.medical_services_outlined;
      case 'companion care':
        return Icons.people_outline_rounded;
      default:
        return Icons.category_outlined;
    }
  }
}
