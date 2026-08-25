import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:carely_caregiver/screens/client_screen/my_booking_screen/controller/my_booking_controller.dart';
import 'package:carely_caregiver/screens/client_screen/my_booking_screen/widgets/my_booking_widgets.dart';
import 'package:carely_caregiver/widgets/default_background_template.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';

class MyBookingScreen extends StatelessWidget {
  const MyBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(MyBookingController());
    final colors = AppColors.instance;

    return DefaultBackgroundTemplate(
      appBarTitle: 'My Bookings',
      hideBackButton: true,
      child: Column(
        children: [
          // ── Status Filters ──────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Obx(
                () => Row(
                  children: c.statuses.map((status) {
                    final isSelected = c.selectedStatus.value == status;
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: () => c.onStatusSelected(status),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? colors.primary : colors.boxBg.withAlpha(50),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: CommonText(
                            text: c.formatStatus(status),
                            fontSize: 14,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            textColor: isSelected ? Colors.white : colors.secondaryText,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),

          // ── Booking List ────────────────────────────────
          Expanded(
            child: Obx(() {
              if (c.isLoading.value && c.bookings.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (c.bookings.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_today_outlined, size: 60, color: Colors.grey.shade300),
                      const SizedBox(height: 16),
                      CommonText(
                        text: 'No ${c.formatStatus(c.selectedStatus.value).toLowerCase()} bookings found',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        textColor: Colors.grey,
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async => c.fetchMyBookings(),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: c.bookings.length,
                  itemBuilder: (context, index) {
                    final booking = c.bookings[index];
                    return ClientBookingCard(
                      booking: booking,
                      onTap: () {
                        Get.toNamed(AppRoutes.instance.clientBookingDetails, arguments: booking.id);
                      },
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
