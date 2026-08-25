import 'package:carely_caregiver/repositories/caregiver_repository.dart';
import 'package:carely_caregiver/widgets/show_custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../widgets/app_calendar_controller.dart';

// ─────────────────────────────────────────────
//  Shift Model
// ─────────────────────────────────────────────
class Shift {
  final String id;
  final String availabilityId; // Parent ID for Edit/Delete API
  final String label;
  final String startTime; // "08:00 AM" for UI
  final String endTime;   // "12:00 PM" for UI
  final String apiStartTime; // "08:00" for API
  final String apiEndTime;   // "12:00" for API
  final String shiftType; // "MORNING", "AFTERNOON", "EVENING"
  final String icon; // 'morning' | 'evening' | 'night'

  const Shift({
    required this.id,
    required this.availabilityId,
    required this.label,
    required this.startTime,
    required this.endTime,
    required this.apiStartTime,
    required this.apiEndTime,
    required this.shiftType,
    required this.icon,
  });

  String get timeRange => '$startTime - $endTime';
}

// ─────────────────────────────────────────────
//  Controller
// ─────────────────────────────────────────────
class AvailabilityScreenController extends GetxController
    with AppCalendarController {
  // ── Calendar ──────────────────────────────
  final Rx<DateTime> focusedMonth = DateTime.now().obs;
  final Rx<DateTime> selectedDay = DateTime.now().obs;

   void  previousMonth() => focusedMonth.value = DateTime(
    focusedMonth.value.year,
    focusedMonth.value.month - 1,
  );
  void nextMonth() => focusedMonth.value = DateTime(
    focusedMonth.value.year,
    focusedMonth.value.month + 1,
  );
  RxBool rebuild = false.obs;

  RxBool isFetching = false.obs;
  final RxBool isSaving = false.obs;

  void selectDay(DateTime day) {
    if (day.month != focusedMonth.value.month) return;
    rebuild.value = !rebuild.value;
    selectedDay.value = day;
    
    fetchAvailabilityForMonth();
  }

  bool isSelected(DateTime d) =>
      d.year == selectedDay.value.year &&
      d.month == selectedDay.value.month &&
      d.day == selectedDay.value.day;
  bool isToday(DateTime d) {
    final n = DateTime.now();
    return d.year == n.year && d.month == n.month && d.day == n.day;
  }

  List<DateTime> get calendarDays {
    final first = DateTime(
      focusedMonth.value.year,
      focusedMonth.value.month,
      1,
    );
    final start = first.subtract(Duration(days: first.weekday % 7));
    return List.generate(42, (i) => start.add(Duration(days: i)));
  }

  // ── Shifts (keyed by date string) ─────────
  final RxMap<String, List<Shift>> _shifts = <String, List<Shift>>{}.obs;

  String _key(DateTime d) => DateFormat('yyyy-MM-dd').format(d);

  List<Shift> get shiftsForSelected => _shifts[_key(selectedDay.value)] ?? [];

  String get selectedDateLabel => DateFormat('MMM d').format(selectedDay.value);

  @override
  void onInit() {
    super.onInit();
    // Fetch initial data for the current month
    fetchAvailabilityForMonth();
    
    // Watch for month changes to fetch new data
    ever(focusedMonth, (_) => fetchAvailabilityForMonth());
  }

  Future<void> fetchAvailabilityForMonth() async {
    try {
      isFetching.value = true;
      update();

      final firstDay = DateTime(focusedMonth.value.year, focusedMonth.value.month, 1);
      final lastDay = DateTime(focusedMonth.value.year, focusedMonth.value.month + 1, 0);

      final startStr = _key(firstDay);
      final endStr = _key(lastDay);

      debugPrint("Fetching availability from $startStr to $endStr");
      final response = await CaregiverRepository.instance.getAvailability(
        startDate: startStr,
        endDate: endStr,
      );

      debugPrint("Availability API Response: ${response.data}");

      if (response.isSuccess) {
        final List dataList = response.data['data'] ?? [];
        
        // Clear existing shifts to map fresh data from API
        _shifts.clear();

        for (var dayData in dataList) {
          final String availabilityId = dayData['_id'] ?? "";
          final String rawDate = dayData['date'] ?? "";
          if (rawDate.isEmpty) continue;

          final dateObj = DateTime.parse(rawDate);
          final String key = _key(dateObj);
          
          final List shiftList = dayData['shifts'] ?? [];
          final List<Shift> mappedShifts = [];

          for (var s in shiftList) {
            final type = s['shiftType'] ?? "MORNING";
            final start = s['startTime'] ?? "00:00";
            final end = s['endTime'] ?? "00:00";

            final label = '${type.toString().toLowerCase()} Shift';
            
            mappedShifts.add(
              Shift(
                id: s['_id'] ?? DateTime.now().toString(),
                availabilityId: availabilityId,
                label: label,
                startTime: _formatToUiTime(start),
                endTime: _formatToUiTime(end),
                apiStartTime: start,
                apiEndTime: end,
                shiftType: type,
                icon: type.toString().toLowerCase(),
              ),
            );
          }
          
          _shifts[key] = mappedShifts;
        }
        _shifts.refresh();
      }
    } catch (e) {
      debugPrint("Error fetching availability: $e");
    } finally {
      isFetching.value = false;
      update();
    }
  }

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

  Future<void> saveShiftToApi(Shift shift) async {
    try {
      isSaving.value = true;
      update();

      final body = {
        "date": _key(selectedDay.value),
        "shiftType": shift.shiftType,
        "startTime": shift.apiStartTime,
        "endTime": shift.apiEndTime,
      };

      final response = await CaregiverRepository.instance.addAvailability(data: body);

      if (response.isSuccess) {
        // After successful add, we refresh from API to get the correct IDs
        await fetchAvailabilityForMonth();
        showCustomSnackbar(message: "Shift added successfully", isError: false);
      } else {
        showCustomSnackbar(message: response.message, isError: true);
      }
    } catch (e) {
      showCustomSnackbar(message: "Failed to add shift", isError: true);
    } finally {
      isSaving.value = false;
      update();
    }
  }

  Future<void> updateShiftInApi(Shift shift) async {
    try {
      isSaving.value = true;
      update();

      final body = {
        "date": _key(selectedDay.value),
        "shiftType": shift.shiftType,
        "startTime": shift.apiStartTime,
        "endTime": shift.apiEndTime,
      };

      final response = await CaregiverRepository.instance.updateShift(
        availabilityId: shift.availabilityId,
        shiftId: shift.id,
        data: body,
      );

      if (response.isSuccess) {
        await fetchAvailabilityForMonth();
        showCustomSnackbar(message: "Shift updated successfully", isError: false);
      } else {
        showCustomSnackbar(message: response.message, isError: true);
      }
    } catch (e) {
      showCustomSnackbar(message: "Failed to update shift", isError: true);
    } finally {
      isSaving.value = false;
      update();
    }
  }

  Future<void> deleteShiftFromApi(Shift shift) async {
    try {
      isSaving.value = true;
      update();

      final response = await CaregiverRepository.instance.deleteShift(
        availabilityId: shift.availabilityId,
        shiftId: shift.id,
      );

      if (response.isSuccess) {
        _deleteLocalShift(shift.id);
        showCustomSnackbar(message: "Shift deleted successfully", isError: false);
      } else {
        showCustomSnackbar(message: response.message, isError: true);
      }
    } catch (e) {
      showCustomSnackbar(message: "Failed to delete shift", isError: true);
    } finally {
      isSaving.value = false;
      update();
    }
  }

  void addShift(Shift shift) {
    final k = _key(selectedDay.value);
    _shifts[k] = [...?_shifts[k], shift];
    _shifts.refresh();
  }

  void _deleteLocalShift(String id) {
    final k = _key(selectedDay.value);
    _shifts[k] = (_shifts[k] ?? []).where((s) => s.id != id).toList();
    _shifts.refresh();
  }

  final Rx<DateTime> lastSynced = DateTime.now().obs;
  String get lastSyncedLabel => DateFormat('hh:mm a').format(lastSynced.value);
}
