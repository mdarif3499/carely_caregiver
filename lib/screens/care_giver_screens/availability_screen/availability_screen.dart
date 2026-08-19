import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:carely_caregiver/screens/care_giver_screens/availability_screen/widget/availability_widgets.dart';
import 'package:carely_caregiver/screens/care_giver_screens/availability_screen/controller/availability_screen_controller.dart';
import 'package:carely_caregiver/utils/error_log.dart';
import 'package:carely_caregiver/widgets/app_calendar.dart';
import 'package:carely_caregiver/widgets/default_background_template.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AvailabilityScreen extends StatelessWidget {
  const AvailabilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AvailabilityScreenController>();
    final colors = AppColors.instance;

    return DefaultBackgroundTemplate(
      appBarTitle: 'Availability',
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    errorLog('availabily ui update${c.rebuild.value}', 'AvailabilityScreen');
                    return AppCalendar(controller: c);
                  }),
                  24.height,
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonText(
                          text: '${c.selectedDateLabel} Schedule',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          textColor: colors.textPrimary,
                          isDescription: true,
                          preventScaling: true,
                        ),
                        GestureDetector(
                          onTap: () => _showAddShiftSheet(context, c),
                          child: CommonText(
                            text: '+ Add Shift',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            textColor: colors.primary,
                            isDescription: true,
                            preventScaling: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  16.height,

                  Obx(() {
                    if (c.isFetching.value && c.shiftsForSelected.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 60),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final shifts = c.shiftsForSelected;
                    if (shifts.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 24),
                        child: Center(
                          child: CommonText(
                            text:
                                'No shifts for this day.\nTap + Add Shift to schedule.',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            textColor: colors.secondaryText,
                            isDescription: true,
                            preventScaling: true,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                    return Column(
                      children: shifts
                          .map(
                            (s) => ShiftCard(
                              shift: s,
                              onDelete: () => _showDeleteConfirmation(context, c, s),
                              onEdit: () =>
                                  _showAddShiftSheet(context, c, existing: s),
                            ),
                          )
                          .toList(),
                    );
                  }),
                ],
              ),
            ),
          ),


          Obx(
            () => Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.sync_rounded,
                    size: 14,
                    color: colors.secondaryText,
                  ),
                  6.width,
                  CommonText(
                    text: 'LAST SYNCED: ${c.lastSyncedLabel}',
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    textColor: colors.secondaryText,
                    isDescription: true,
                    preventScaling: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, AvailabilityScreenController c, Shift shift) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
        title: const CommonText(
          text: 'Delete Shift?',
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        content: CommonText(
          text: 'Are you sure you want to remove this ${shift.label}? This action cannot be undone.',
          fontSize: 14,
          textColor: AppColors.instance.secondaryText,
        ),
        actionsPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: CommonText(
              text: 'Cancel',
              fontWeight: FontWeight.w600,
              textColor: AppColors.instance.textGrey,
            ),
          ),
          SizedBox(
            width: 100.w,
            child: CommonButton(
              titleText: 'Delete',
              buttonColor: AppColors.instance.error,
              onTap: () {
                Get.back();
                c.deleteShiftFromApi(shift);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddShiftSheet(
    BuildContext context,
    AvailabilityScreenController c, {
    Shift? existing,
  }) {
    RxString selectedType = (existing?.shiftType ?? 'MORNING').obs;
    Rx<TimeOfDay> startTime = const TimeOfDay(hour: 8, minute: 0).obs;
    Rx<TimeOfDay> endTime = const TimeOfDay(hour: 12, minute: 0).obs;

    if (existing != null) {
      final startParts = existing.apiStartTime.split(':');
      final endParts = existing.apiEndTime.split(':');
      startTime.value = TimeOfDay(hour: int.parse(startParts[0]), minute: int.parse(startParts[1]));
      endTime.value = TimeOfDay(hour: int.parse(endParts[0]), minute: int.parse(endParts[1]));
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 30,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            24.height,
            CommonText(
              text: existing != null ? 'Edit Shift Schedule' : 'Add New Shift',
              fontSize: 22,
              fontWeight: FontWeight.w800,
              textColor: AppColors.instance.textPrimary,
            ),
            8.height,
            CommonText(
              text: 'Set your availability for ${c.selectedDateLabel}',
              fontSize: 14,
              textColor: AppColors.instance.secondaryText,
            ),
            32.height,

            // ── Shift Type Selector ────────────────
            const CommonText(
              text: 'Shift Type',
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
            16.height,
            Obx(
              () => Row(
                children: [
                  _ShiftTypeBtn(
                    label: 'Morning',
                    icon: Icons.wb_sunny_outlined,
                    isSelected: selectedType.value == 'MORNING',
                    onTap: () => selectedType.value = 'MORNING',
                  ),
                  12.width,
                  _ShiftTypeBtn(
                    label: 'Afternoon',
                    icon: Icons.wb_twilight_rounded,
                    isSelected: selectedType.value == 'AFTERNOON',
                    onTap: () => selectedType.value = 'AFTERNOON',
                  ),
                  12.width,
                  _ShiftTypeBtn(
                    label: 'Evening',
                    icon: Icons.nightlight_outlined,
                    isSelected: selectedType.value == 'EVENING',
                    onTap: () => selectedType.value = 'EVENING',
                  ),
                ],
              ),
            ),
            32.height,

            // ── Time Range ────────────────────────
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CommonText(text: 'Start Time', fontSize: 14, fontWeight: FontWeight.w600),
                      8.height,
                      Obx(() => _TimePickerBox(
                        time: startTime.value,
                        onTap: () async {
                          final picked = await showTimePicker(context: context, initialTime: startTime.value);
                          if (picked != null) startTime.value = picked;
                        },
                      )),
                    ],
                  ),
                ),
                20.width,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CommonText(text: 'End Time', fontSize: 14, fontWeight: FontWeight.w600),
                      8.height,
                      Obx(() => _TimePickerBox(
                        time: endTime.value,
                        onTap: () async {
                          final picked = await showTimePicker(context: context, initialTime: endTime.value);
                          if (picked != null) endTime.value = picked;
                        },
                      )),
                    ],
                  ),
                ),
              ],
            ),
            40.height,

            // ── Action Button ──────────────────────
            SizedBox(
              width: double.infinity,
              child: CommonButton(
                titleText: existing != null ? 'Update Shift' : 'Add Shift',
                onTap: () {
                  final startStr = startTime.value.format(context);
                  final endStr = endTime.value.format(context);
                  final apiStart = '${startTime.value.hour.toString().padLeft(2, '0')}:${startTime.value.minute.toString().padLeft(2, '0')}';
                  final apiEnd = '${endTime.value.hour.toString().padLeft(2, '0')}:${endTime.value.minute.toString().padLeft(2, '0')}';
                  
                  if (existing != null) {
                    c.updateShiftInApi(
                      Shift(
                        id: existing.id,
                        availabilityId: existing.availabilityId,
                        label: '${selectedType.value} Shift',
                        startTime: startStr,
                        endTime: endStr,
                        apiStartTime: apiStart,
                        apiEndTime: apiEnd,
                        shiftType: selectedType.value,
                        icon: selectedType.value.toLowerCase(),
                      ),
                    );
                  } else {
                    c.saveShiftToApi(
                      Shift(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        availabilityId: "", // Will be assigned by API on refresh
                        label: '${selectedType.value} Shift',
                        startTime: startStr,
                        endTime: endStr,
                        apiStartTime: apiStart,
                        apiEndTime: apiEnd,
                        shiftType: selectedType.value,
                        icon: selectedType.value.toLowerCase(),
                      ),
                    );
                  }
                  Get.back();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShiftTypeBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ShiftTypeBtn({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? colors.primary : colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? colors.primary : colors.boxBg,
              width: 2,
            ),
            boxShadow: isSelected ? [
              BoxShadow(
                color: colors.primary.withAlpha(40),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            ] : null,
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? Colors.white : colors.textGrey, size: 24),
              8.height,
              CommonText(
                text: label,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                textColor: isSelected ? Colors.white : colors.textPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimePickerBox extends StatelessWidget {
  final TimeOfDay time;
  final VoidCallback onTap;

  const _TimePickerBox({required this.time, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: colors.boxBg.withAlpha(50),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.boxBg),
        ),
        child: Row(
          children: [
            Icon(Icons.access_time_rounded, size: 18, color: colors.primary),
            10.width,
            CommonText(
              text: time.format(context),
              fontSize: 15,
              fontWeight: FontWeight.w600,
              textColor: colors.textPrimary,
            ),
          ],
        ),
      ),
    );
  }
}


///   12:53:35[GETX] GOING TO ROUTE /app-navigation-screen
///   [GETX] REMOVING ROUTE /
///   [GETX] Instance "AppNavigationScreenController" has been created
///   [GETX] Instance "AppNavigationScreenController" has been initialized
///   [GETX] Instance "ClientHomeController" has been created
///   [GETX] Instance "ClientHomeController" has been initialized
///   [GETX] Instance "FindCaregiverController" has been created
///   [GETX] Instance "FindCaregiverController" has been initialized
///   [GETX] Instance "SelectedServiceTypeController" has been created
///   GETX] Instance "SelectedServiceTypeController" has been initialized