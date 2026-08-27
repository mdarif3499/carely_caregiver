import 'package:carely_caregiver/screens/care_giver_screens/all_schedule_screen/controller/all_schedule_controller.dart';
import 'package:carely_caregiver/screens/care_giver_screens/all_schedule_screen/widgets/all_schedule_widgets.dart';
import 'package:carely_caregiver/widgets/default_background_template.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AllScheduleScreen extends StatelessWidget {
  const AllScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(AllScheduleController());
    final String todayLabel = DateFormat('MMMM d, yyyy').format(DateTime.now());

    return DefaultBackgroundTemplate(
      appBarTitle: "Today's Schedule",
      child: Obx(() {
        final schedules = c.schedules;
        
        return Skeletonizer(
          enabled: c.isLoading.value,
          child: schedules.isEmpty && !c.isLoading.value
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_today_outlined, size: 64.sp, color: Colors.grey.shade300),
                      SizedBox(height: 16.h),
                      CommonText(
                        text: 'No bookings for today',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        textColor: Colors.grey,
                      ),
                      SizedBox(height: 8.h),
                      CommonText(
                        text: todayLabel,
                        fontSize: 14.sp,
                        textColor: Colors.grey.shade400,
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async => c.onRefresh(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 12.h),
                        child: CommonText(
                          text: todayLabel,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          textColor: Colors.grey.shade600,
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                          itemCount: schedules.length,
                          itemBuilder: (context, index) {
                            final item = schedules[index];
                            return ScheduleDetailCard(
                              item: item,
                              onTap: () => c.onViewDetails(item),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
        );
      }),
    );
  }
}
