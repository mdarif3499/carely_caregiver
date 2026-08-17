import 'package:carely_caregiver/screens/app_navigation_screen/controller/app_navigation_screen_controller.dart';
import 'package:carely_caregiver/screens/care_giver_screens/care_giver_home_screen/controller/care_giver_home_controller.dart';
import 'package:carely_caregiver/screens/care_giver_screens/care_giver_home_screen/widgets/care_giver_home_widgets.dart';
import 'package:carely_caregiver/screens/care_giver_screens/earning_screen/widgets/earning_widgets.dart';
import 'package:carely_caregiver/widgets/default_background_template.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constant/app_colors.dart';

class CareGiverHomeScreen extends StatelessWidget {
  const CareGiverHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<CareGiverHomeController>();
    final navC = Get.find<AppNavigationScreenController>();
    final colors = AppColors.instance;

    return DefaultBackgroundTemplate(
      titleWidget: Obx(
        () => CareGiverHeader(
          userName: navC.userModel.value?.name ?? "...",
          avatarUrl: navC.userModel.value?.profileImage ?? "",
          onNotificationTap: c.onNotificationTap,
        ),
      ),
      hideBackButton: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Weekly Earnings Chart Card ───────────────
            Obx(
              () => WeeklyEarningsChartCard(
                totalEarnings: c.totalWeeklyEarnings.value,
                bars: c.weeklyBars.toList(),
              ),
            ),
            const SizedBox(height: 32),

            // ── Today's Schedule Section ────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonText(
                  text: "Today's Schedule",
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  textColor: colors.textPrimary,
                ),
                GestureDetector(
                  onTap: c.onSeeAllSchedule,
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
              () => Column(
                children: c.todaySchedule
                    .map((item) => CareGiverScheduleCard(
                          item: item,
                          onTap: () => c.onViewDetails(item),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
