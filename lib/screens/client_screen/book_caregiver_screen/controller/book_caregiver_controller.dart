import 'package:carely_caregiver/repositories/client_repository.dart';
import 'package:carely_caregiver/routes/app_routes.dart';
import 'package:carely_caregiver/screens/client_screen/find_caregiver_screen/controller/find_caregiver_controller.dart';
import 'package:carely_caregiver/utils/log/app_log.dart';
import 'package:carely_caregiver/widgets/app_calendar_controller.dart';
import 'package:carely_caregiver/widgets/show_custom_snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// ── Time Slot Model ──────────────────────────────────────
class TimeSlot {
  final String startTime;
  final String status;

  const TimeSlot({required this.startTime, required this.status});

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      startTime: json['startTime'] ?? "",
      status: json['status'] ?? "",
    );
  }

  String get label => _formatToUiTime(startTime);

  String _formatToUiTime(String apiTime) {
    try {
      final parts = apiTime.split(':');
      final hour = int.parse(parts[0]);
      final min = int.parse(parts[1]);
      final dt = DateTime(0, 1, 1, hour, min);
      return DateFormat('hh:mm a').format(dt);
    } catch (e) {
      return apiTime;
    }
  }
}

// ── Shift Model ──────────────────────────────────────────
class CaregiverShift {
  final String shiftType;
  final List<TimeSlot> slots;

  const CaregiverShift({required this.shiftType, required this.slots});

  factory CaregiverShift.fromJson(Map<String, dynamic> json) {
    final List slotList = json['slots'] ?? [];
    return CaregiverShift(
      shiftType: json['shiftType'] ?? "MORNING",
      slots: slotList.map((s) => TimeSlot.fromJson(s)).toList(),
    );
  }
}

// ── Controller ───────────────────────────────────────────
class BookCaregiverController extends GetxController
    with AppCalendarController {
  
  final Rxn<CaregiverModel> caregiver = Rxn<CaregiverModel>();
  final RxBool isLoading = false.obs;
  
  RxBool rebuild = false.obs;
  // ── Calendar ──
  final Rx<DateTime> focusedMonth = DateTime.now().obs;
  final Rx<DateTime> selectedDay = DateTime.now().obs;

  // ── API Data ──
  final RxList<CaregiverShift> availableShifts = <CaregiverShift>[].obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is CaregiverModel) {
      caregiver.value = args;
    }
    
    // Initial fetch
    fetchCaregiverAvailability();
  }

  Future<void> fetchCaregiverAvailability() async {
    final id = caregiver.value?.id;
    if (id == null || id.isEmpty) {
      appLog("Cannot fetch availability: Caregiver ID is null or empty", source: "AVAILABILITY_API");
      return;
    }

    try {
      isLoading.value = true;
      update();

      final selectedDate = selectedDay.value;
      final dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);

      appLog("STARTING API CALL - ID: $id, Date: $dateStr", source: "AVAILABILITY_API");
      
      final response = await ClientRepository.instance.getCaregiverAvailability(
        caregiverId: id,
        startDate: dateStr,
        endDate: dateStr,
      );

      appLog("Caregiver Availability Response Status: ${response.statusCode}", source: "AVAILABILITY_API");
      appLog("Caregiver Availability Response Body: ${response.data}", source: "AVAILABILITY_API");

      if (response.isSuccess) {
        final List dataList = response.data['data'] ?? [];
        availableShifts.clear();

        if (dataList.isNotEmpty) {
          final dayData = dataList[0];
          final List shiftList = dayData['shifts'] ?? [];
          
          // 1. Collect all slots into a single list
          List<TimeSlot> allSlots = [];
          for (var s in shiftList) {
            final List slotList = s['slots'] ?? [];
            allSlots.addAll(slotList.map((slotJson) => TimeSlot.fromJson(slotJson)));
          }

          // 2. Group slots by their actual time (International Standard)
          Map<String, List<TimeSlot>> grouped = {
            'MORNING': [],
            'AFTERNOON': [],
            'EVENING': [],
          };

          for (var slot in allSlots) {
            final hour = int.tryParse(slot.startTime.split(':')[0]) ?? 0;
            if (hour < 12) {
              grouped['MORNING']!.add(slot);
            } else if (hour < 17) {
              grouped['AFTERNOON']!.add(slot);
            } else {
              grouped['EVENING']!.add(slot);
            }
          }

          // 3. Convert grouped map back to availableShifts list (only non-empty groups)
          grouped.forEach((type, slots) {
            if (slots.isNotEmpty) {
              // Sort slots by time within the group
              slots.sort((a, b) => a.startTime.compareTo(b.startTime));
              availableShifts.add(CaregiverShift(shiftType: type, slots: slots));
            }
          });
        }
      } else {
        showCustomSnackbar(message: response.message, isError: true);
      }
    } catch (e) {
      appLog("Error fetching caregiver availability: $e", source: "AVAILABILITY_API");
    } finally {
      isLoading.value = false;
      update();
    }
  }

  void previousMonth() {
    focusedMonth.value = DateTime(
      focusedMonth.value.year,
      focusedMonth.value.month - 1,
    );
  }

  void nextMonth() {
    focusedMonth.value = DateTime(
      focusedMonth.value.year,
      focusedMonth.value.month + 1,
    );
  }

  void selectDay(DateTime day) {
    if (day.month != focusedMonth.value.month) return;
    selectedDay.value = day;
    rebuild.value = !rebuild.value;
    
    // Clear selected slot when changing date
    selectedSlot.value = null;
    availableShifts.clear();
    
    // Trigger API call
    fetchCaregiverAvailability();
  }

  bool isSelected(DateTime day) {
    final s = selectedDay.value;
    return s.year == day.year && s.month == day.month && s.day == day.day;
  }

  bool isToday(DateTime day) {
    final now = DateTime.now();
    return day.year == now.year && day.month == now.month && day.day == now.day;
  }

  List<DateTime> get calendarDays {
    final first = DateTime(
      focusedMonth.value.year,
      focusedMonth.value.month,
      1,
    );
    final startOffset = first.weekday % 7;
    final start = first.subtract(Duration(days: startOffset));
    return List.generate(42, (i) => start.add(Duration(days: i)));
  }

  final Rx<TimeSlot?> selectedSlot = Rx<TimeSlot?>(null);

  void selectSlot(TimeSlot slot) {
    selectedSlot.value = slot;
  }

  bool isSlotSelected(TimeSlot slot) => selectedSlot.value?.startTime == slot.startTime;

  // ── Summary ──
  String get selectedScheduleText {
    final day = selectedDay.value;
    final slot = selectedSlot.value;
    if (slot == null) return 'No schedule selected';
    final formatted = DateFormat('MMM d').format(day);
    return '$formatted, ${slot.label}';
  }

  void confirmSchedule() {
    if (selectedSlot.value == null) {
      showCustomSnackbar(
        message: 'Please select a date and time.',
        isError: true,
      );
      return;
    }
    Get.toNamed(AppRoutes.instance.reviewBookingScreen);
  }
}
