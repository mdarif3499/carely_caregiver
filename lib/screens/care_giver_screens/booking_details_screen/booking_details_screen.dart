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
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClientProfileHeader(booking: ctrl.booking),
                  20.height,
                  ScheduleEarningsCard(booking: ctrl.booking),
                  20.height,
                  AdditionalInstructionsCard(
                    instructions: ctrl.booking.additionalInstructions,
                  ),
                ],
              ),
            ),
          ),
          Obx(
            () => Padding(
              padding: const EdgeInsets.all(16.0),
              child: BookingDetailActions(
                isLoading: ctrl.isLoading.value,
                onAccept: ctrl.accept,
                onDecline: ctrl.decline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
