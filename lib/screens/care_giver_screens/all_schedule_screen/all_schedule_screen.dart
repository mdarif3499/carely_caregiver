import 'package:carely_caregiver/screens/care_giver_screens/all_schedule_screen/controller/all_schedule_controller.dart';
import 'package:carely_caregiver/screens/care_giver_screens/all_schedule_screen/widgets/all_schedule_widgets.dart';
import 'package:carely_caregiver/widgets/default_background_template.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AllScheduleScreen extends StatelessWidget {
  const AllScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(AllScheduleController());
    final String todayLabel = DateFormat('MMMM d, yyyy').format(DateTime.now());

    return DefaultBackgroundTemplate(
      appBarTitle: "Today's Schedule",
      child: Obx(() {
        if (c.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (c.schedules.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today_outlined, size: 64, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                const CommonText(
                  text: 'No bookings for today',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  textColor: Colors.grey,
                ),
                const SizedBox(height: 8),
                CommonText(
                  text: todayLabel,
                  fontSize: 14,
                  textColor: Colors.grey.shade400,
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async => c.onRefresh(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: CommonText(
                  text: todayLabel,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  textColor: Colors.grey.shade600,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  itemCount: c.schedules.length,
                  itemBuilder: (context, index) {
                    return ScheduleDetailCard(item: c.schedules[index]);
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
