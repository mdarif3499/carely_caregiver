import 'package:carely_caregiver/screens/notification_screen/controller/notification_screen_controller.dart';
import 'package:carely_caregiver/screens/notification_screen/widgets/notification_widgets.dart';
import 'package:carely_caregiver/widgets/default_background_template.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<NotificationScreenController>();

    return DefaultBackgroundTemplate(
      appBarTitle: 'Notifications',
      child: Obx(() {
        final items = c.flatItems;
        final filter = c.activeFilter.value;

        // ── Header (Fixed) ──────────────
        final header = Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: NotificationFilterRow(active: filter, onTap: c.setFilter),
        );

        return Skeletonizer(
          enabled: c.isLoading.value,
          child: Column(
            children: [
              header,
              Expanded(
                child: items.isEmpty && !c.isLoading.value
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.notifications_off_outlined,
                              size: 64,
                              color: Colors.grey.shade300,
                            ),
                            const SizedBox(height: 16),
                            const CommonText(
                              text: 'No notifications found',
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              textColor: Colors.grey,
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () => c.fetchNotifications(isRefresh: true),
                        child: SmartListLoader(
                          itemCount: items.length,
                          isLoading: c.isMoreLoading.value,
                          onLoadMore: (_) => c.loadMore(),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemBuilder: (_, index) {
                            final item = items[index];
                            if (item.isLabel) {
                              return NotificationGroupLabel(label: item.groupLabel!);
                            }
                            return NotificationItem(
                              notification: item.notification!,
                              onTap: () => c.onNotificationTap(item.notification!),
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
