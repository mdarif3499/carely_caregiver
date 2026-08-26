import 'package:carely_caregiver/screens/notification_screen/controller/notification_screen_controller.dart';
import 'package:carely_caregiver/screens/notification_screen/widgets/notification_widgets.dart';
import 'package:carely_caregiver/widgets/default_background_template.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

        // ── Expanded header: filter chips ──────────────
        final expandedHeader = Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: NotificationFilterRow(active: filter, onTap: c.setFilter),
        );

        // ── Collapsed header: compact chips on scroll ──
        final collapsedHeader = Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: NotificationFilterRow(active: filter, onTap: c.setFilter),
        );

        // ── Empty state ────────────────────────────────
        if (items.isEmpty) {
          return Column(
            children: [
              expandedHeader,
              const SizedBox(height: 80),
              Icon(
                Icons.notifications_off_outlined,
                size: 56,
                color: Colors.grey.shade300,
              ),
              12.height,
              const CommonText(
                text: 'No notifications',
                fontSize: 15,
                fontWeight: FontWeight.w500,
                textColor: Colors.grey,
                isDescription: true,
                preventScaling: true,
              ),
            ],
          );
        }

        // ── SmartListLoader ────────────────────────────
        return SmartListLoader(
          itemCount: items.length,
          appbar: expandedHeader,
          onColapsAppbar: collapsedHeader,
          padding: const EdgeInsets.only(bottom: 24),
          itemBuilder: (_, index) {
            final item = items[index];
            if (item.isLabel) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: NotificationGroupLabel(label: item.groupLabel!),
              );
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: NotificationItem(notification: item.notification!),
            );
          },
        );
      }),
    );
  }
}
