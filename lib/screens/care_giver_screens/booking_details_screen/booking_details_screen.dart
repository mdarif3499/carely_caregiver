import 'package:carely_caregiver/screens/care_giver_screens/booking_details_screen/widgets/booking_details_widgets.dart';
import 'package:carely_caregiver/screens/care_giver_screens/booking_details_screen/controller/booking_details_controller.dart';
import 'package:carely_caregiver/widgets/default_background_template.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingDetailsScreen extends StatelessWidget {
  const BookingDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<BookingDetailsController>();

    return DefaultBackgroundTemplate(
      appBarTitle: 'Booking Details',
      child: Obx(() {
        if (ctrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final BookingDetails? b = ctrl.booking.value;
        if (b == null) {
          return const Center(child: CommonText(text: 'Booking not found'));
        }

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClientProfileHeader(booking: b),
                    20.height,
                    ScheduleEarningsCard(booking: b),
                    20.height,
                    AdditionalInstructionsCard(
                      instructions: b.instructions,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: BookingDetailActions(
                isLoading: ctrl.isActionLoading.value,
                status: b.status,
                onAccept: ctrl.accept,
                onDecline: ctrl.decline,
              ),
            ),
          ],
        );
      }),
    );
  }
}
