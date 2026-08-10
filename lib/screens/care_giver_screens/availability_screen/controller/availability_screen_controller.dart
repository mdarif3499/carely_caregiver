import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../widgets/app_calendar_controller.dart';

// ─────────────────────────────────────────────
//  Shift Model
// ─────────────────────────────────────────────
class Shift {
  final String id;
  final String label;
  final String startTime;
  final String endTime;
  final String icon; // 'morning' | 'evening' | 'night'

  const Shift({
    required this.id,
    required this.label,
    required this.startTime,
    required this.endTime,
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

  void previousMonth() => focusedMonth.value = DateTime(
    focusedMonth.value.year,
    focusedMonth.value.month - 1,
  );
  void nextMonth() => focusedMonth.value = DateTime(
    focusedMonth.value.year,
    focusedMonth.value.month + 1,
  );
  RxBool rebuild = false.obs;

  void selectDay(DateTime day) {
    if (day.month != focusedMonth.value.month) return;
    rebuild.value = !rebuild.value;
    selectedDay.value = day;
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
    // seed today with two sample shifts
    final k = _key(DateTime.now());
    _shifts[k] = [
      const Shift(
        id: '1',
        label: 'Morning Shift',
        startTime: '08:00 AM',
        endTime: '12:00 PM',
        icon: 'morning',
      ),
      const Shift(
        id: '2',
        label: 'Evening Shift',
        startTime: '05:00 PM',
        endTime: '09:00 PM',
        icon: 'evening',
      ),
    ];
  }

  void addShift(Shift shift) {
    final k = _key(selectedDay.value);
    _shifts[k] = [...?_shifts[k], shift];
    _shifts.refresh();
  }

  void deleteShift(String id) {
    final k = _key(selectedDay.value);
    _shifts[k] = (_shifts[k] ?? []).where((s) => s.id != id).toList();
    _shifts.refresh();
  }

  final RxBool isSaving = false.obs;
  final Rx<DateTime> lastSynced = DateTime.now().obs;

  Future<void> confirmChanges() async {
    isSaving.value = true;
    await Future.delayed(const Duration(milliseconds: 800));
    lastSynced.value = DateTime.now();
    isSaving.value = false;
  }
}
