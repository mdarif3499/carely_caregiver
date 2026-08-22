import 'package:carely_caregiver/routes/app_routes.dart';
import 'package:carely_caregiver/screens/care_giver_screens/booking_request_screen/widgets/booking_request_widgets.dart';
import 'package:carely_caregiver/screens/care_giver_screens/booking_request_screen/controller/booking_request_controller.dart';
import 'package:carely_caregiver/widgets/default_background_template.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingRequestScreen extends StatelessWidget {
  const BookingRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<BookingRequestController>();

    return DefaultBackgroundTemplate(
      appBarTitle: 'Booking Requests',
      hideBackButton: true,
      child: Obx(() {
        if (c.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final requests = c.activeList;

        // ── Tab bar header ──────────────────────────────
        final header = Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: BookingTabSelector(
            selected: c.selectedTab.value,
            newCount: c.newRequests.length,
            onTap: c.selectTab,
          ),
        );

        // ── Empty state ─────────────────────────────────
        if (requests.isEmpty) {
          return Column(
            children: [
              header,
              const SizedBox(height: 80),
              Icon(Icons.inbox_outlined, size: 60, color: Colors.grey.shade300),
              const SizedBox(height: 12),
              CommonText(
                text: 'No requests found',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                textColor: const Color(0xff7F8C8D),
                isDescription: true,
                preventScaling: true,
              ),
            ],
          );
        }

        // ── Request list via SmartListLoader ────────────
        return SmartListLoader(
          itemCount: requests.length,
          appbar: header,
          padding: const EdgeInsets.only(bottom: 20),
          onColapsAppbar: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: BookingTabSelector(
              selected: c.selectedTab.value,
              newCount: c.newRequests.length,
              onTap: c.selectTab,
            ),
          ),
          itemBuilder: (_, index) {
            final req = requests[index];
            return BookingRequestCard(
              onTap: () {
                Get.toNamed(AppRoutes.instance.bookingDetailsScreen, arguments: req.id);
              },
              request: req,
              isNew: c.selectedTab.value == 0,
              onAccept: () => c.acceptRequest(req.id),
              onDecline: () => c.declineRequest(req.id),
            );
          },
        );
      }),
    );
  }
}
