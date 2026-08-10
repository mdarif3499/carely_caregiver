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
                              onDelete: () => c.deleteShift(s.id),
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
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: CommonButton(
                      titleText: 'Confirm Schedule Changes',
                      buttonColor: colors.primary,
                      titleColor: colors.white,
                      isLoading: c.isSaving.value,
                      onTap: c.isSaving.value ? null : c.confirmChanges,
                    ),
                  ),
                  8.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.sync_rounded,
                        size: 14,
                        color: colors.secondaryText,
                      ),
                      6.width,
                      CommonText(
                        text: 'LAST SYNCED: JUST NOW',
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        textColor: colors.secondaryText,
                        isDescription: true,
                        preventScaling: true,
                      ),
                    ],
                  ),
                ],
              ),
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
  })
  {
    final labels = ['Morning Shift', 'Evening Shift', 'Night Shift'];
    final starts = ['08:00 AM', '05:00 PM', '10:00 PM'];
    final ends = ['12:00 PM', '09:00 PM', '06:00 AM'];
    final icons = ['morning', 'evening', 'night'];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonText(
              text: existing != null ? 'Edit Shift' : 'Add Shift',
              fontSize: 17,
              fontWeight: FontWeight.w700,
              textColor: AppColors.instance.textPrimary,
              isDescription: true,
              preventScaling: true,
            ),
            16.height,
            ...List.generate(
              labels.length,
              (i) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.wb_sunny_rounded,
                  color: AppColors.instance.orange,
                ),
                title: Text(labels[i]),
                subtitle: Text('${starts[i]} - ${ends[i]}'),
                onTap: () {
                  if (existing != null) c.deleteShift(existing.id);
                  c.addShift(
                    Shift(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      label: labels[i],
                      startTime: starts[i],
                      endTime: ends[i],
                      icon: icons[i],
                    ),
                  );
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