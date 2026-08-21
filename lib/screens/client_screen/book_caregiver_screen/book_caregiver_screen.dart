import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:carely_caregiver/screens/client_screen/book_caregiver_screen/controller/book_caregiver_controller.dart';
import 'package:carely_caregiver/screens/client_screen/book_caregiver_screen/widgets/book_caregiver_widgets.dart';
import 'package:carely_caregiver/widgets/app_calendar.dart';
import 'package:carely_caregiver/widgets/default_background_template.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                ],
              ),
            ),
          ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              decoration: BoxDecoration(
                color: colors.white,
                border: Border(top: BorderSide(color: colors.boxBg)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CommonText(
                        text: 'Selected Schedule:',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        textColor: Color(0xFF7F8C8D),
                      ),
                      CommonText(
                        text: controller.selectedScheduleText,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        textColor: colors.primary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CommonButton(
                    titleText: 'Confirm Schedule',
                    onTap: controller.confirmSchedule,
                    buttonWidth: double.infinity,
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  String _getShiftIcon(String type) {
    switch (type.toUpperCase()) {
      case 'MORNING':
        return '☀️';
      case 'AFTERNOON':
        return '🌤️';
      case 'EVENING':
        return '🌙';
      case 'NIGHT':
        return '🌑';
      default:
        return '⏰';
    }
  }
}
