import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:carely_caregiver/screens/client_screen/book_caregiver_screen/controller/book_caregiver_controller.dart';
import 'package:carely_caregiver/screens/client_screen/book_caregiver_screen/widgets/book_caregiver_widgets.dart';
import 'package:carely_caregiver/widgets/app_calendar.dart';
import 'package:carely_caregiver/widgets/default_background_template.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../care_recipients_screen/controller/care_recipients_controller.dart';

class BookCaregiverScreen extends StatelessWidget {
  const BookCaregiverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final BookCaregiverController controller =
        Get.find<BookCaregiverController>();
    final colors = AppColors.instance;

    return DefaultBackgroundTemplate(
      appBarTitle: 'Book Caregiver',
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => CaregiverInfoCard(
                          caregiver: controller.caregiver.value,
                        )),
                    const SizedBox(height: 24),

                    // ── Recipient Selection ───────────────────
                    const CommonText(
                      text: 'Who is this for?',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                    const SizedBox(height: 12),
                    Obx(() {
                      final recipientsController = Get.find<CareRecipientsController>();
                      if (recipientsController.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (recipientsController.recipients.isEmpty) {
                        return CommonText(
                          text: "No recipients found. Please add one.",
                          fontSize: 14,
                          textColor: colors.error,
                        );
                      }
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: recipientsController.recipients.map((r) {
                            return RecipientSelectionCard(
                              recipient: r,
                              isSelected: controller.selectedRecipient.value?.id == r.id,
                              onTap: () => controller.selectedRecipient.value = r,
                            );
                          }).toList(),
                        ),
                      );
                    }),
                    const SizedBox(height: 32),

                    AppCalendar(controller: controller),
                    const SizedBox(height: 32),
                    const CommonText(
                      text: 'Select Time',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                    const SizedBox(height: 20),
                    Obx(
                      () => Column(
                        children: controller.availableShifts.isEmpty && !controller.isLoading.value
                            ? [
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 40),
                                  child: Center(
                                    child: CommonText(
                                      text: 'No available slots for this date.',
                                      fontSize: 16,
                                      textColor: Colors.grey,
                                    ),
                                  ),
                                ),
                              ]
                            : controller.availableShifts
                                .map((shift) => Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TimeGroupLabel(
                                          icon: _getShiftIcon(shift.shiftType),
                                          label: shift.shiftType.toUpperCase(),
                                        ),
                                        const SizedBox(height: 12),
                                        Wrap(
                                          spacing: 12,
                                          runSpacing: 12,
                                          children: shift.slots
                                              .map((slot) => TimeChip(
                                                    slot: slot,
                                                    isSelected: controller.isSlotSelected(slot),
                                                    onTap: () => controller.selectSlot(slot),
                                                  ))
                                              .toList(),
                                        ),
                                        const SizedBox(height: 24),
                                      ],
                                    ))
                                .toList(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const CommonText(
                      text: 'Special Instructions',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: controller.instructionsController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'e.g. Please enter through the side door...',
                        hintStyle: TextStyle(color: colors.textGrey.withAlpha(150), fontSize: 14),
                        filled: true,
                        fillColor: colors.boxBg.withAlpha(30),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: colors.boxBg),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: colors.boxBg),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: colors.primary, width: 1.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            Obx(
              () => Container(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                decoration: BoxDecoration(
                  color: colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(10),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CommonText(
                          text: 'Selected Schedule:',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          textColor: Color(0xFF95A5A6),
                        ),
                        CommonText(
                          text: controller.selectedScheduleText,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          textColor: controller.selectedSlot.value == null ? const Color(0xFF6C5CE7) : colors.primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    CommonButton(
                      titleText: 'Confirm Schedule',
                      isLoading: controller.isBooking.value,
                      onTap: controller.confirmSchedule,
                      buttonWidth: double.infinity,
                      buttonHeight: 52,
                      buttonRadius: 12,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _getShiftIcon(String type) {
    final colors = AppColors.instance;
    switch (type.toUpperCase()) {
      case 'MORNING':
        return Icon(Icons.wb_sunny_rounded, color: Colors.amber, size: 24);
      case 'AFTERNOON':
        return Icon(Icons.wb_twilight_rounded, color: colors.primary, size: 24);
      case 'EVENING':
        return Icon(Icons.nightlight_round, color: Colors.amber, size: 22);
      case 'NIGHT':
        return Icon(Icons.dark_mode_rounded, color: colors.secondaryColor, size: 22);
      default:
        return Icon(Icons.access_time_filled_rounded, color: colors.textGrey, size: 22);
    }
  }
}
