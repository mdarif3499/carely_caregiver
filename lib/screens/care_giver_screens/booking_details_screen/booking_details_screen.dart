import 'package:carely_caregiver/screens/care_giver_screens/booking_details_screen/widgets/booking_details_widgets.dart';
import 'package:carely_caregiver/screens/care_giver_screens/booking_details_screen/controller/booking_details_controller.dart';
import 'package:carely_caregiver/widgets/default_background_template.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BookingDetailsScreen extends StatelessWidget {
  const BookingDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<BookingDetailsController>();

    return DefaultBackgroundTemplate(
      appBarTitle: 'Booking Details',
      child: Obx(() {
        final b = ctrl.booking.value;
        
        return Skeletonizer(
          enabled: ctrl.isLoading.value,
          child: b == null && !ctrl.isLoading.value
              ? const Center(child: CommonText(text: 'Booking not found'))
              : Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(16.r),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClientProfileHeader(booking: b!),
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
                      padding: EdgeInsets.all(16.r),
                      child: BookingDetailActions(
                        isLoading: ctrl.isActionLoading.value,
                        booking: b,
                        onAccept: ctrl.accept,
                        onDecline: ctrl.showDeclineDialog,
                        onComplete: ctrl.complete,
                      ),
                    ),
                  ],
                ),
        );
      }),
    );
  }
}
