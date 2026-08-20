import 'package:carely_caregiver/routes/app_routes.dart';
import 'package:carely_caregiver/screens/client_screen/find_caregiver_screen/controller/find_caregiver_controller.dart';
import 'package:carely_caregiver/widgets/app_calendar_controller.dart';
import 'package:carely_caregiver/widgets/show_custom_snackbar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// ── Time Slot Model ──────────────────────────────────────
class TimeSlot {
  final String label;
  const TimeSlot(this.label);
}

// ── Controller ───────────────────────────────────────────
class BookCaregiverController extends GetxController
    with AppCalendarController {
  
  final Rxn<CaregiverModel> caregiver = Rxn<CaregiverModel>();
  
  RxBool rebuild = false.obs;
  // ── Calendar ──
  final Rx<DateTime> focusedMonth = DateTime.now().obs;
  final Rx<DateTime> selectedDay = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is CaregiverModel) {
      caregiver.value = args;
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
    // Don't select days outside the focused month
    if (day.month != focusedMonth.value.month) return;
    selectedDay.value = day;
    rebuild.value = !rebuild.value;
  }

  bool isSelected(DateTime day) {
    final s = selectedDay.value;
    return s.year == day.year && s.month == day.month && s.day == day.day;
  }

  bool isToday(DateTime day) {
    final now = DateTime.now();
    return day.year == now.year && day.month == now.month && day.day == now.day;
  }

  // Generates the 6-week grid for the focused month
  List<DateTime> get calendarDays {
    final first = DateTime(
      focusedMonth.value.year,
      focusedMonth.value.month,
      1,
    );
    // Start from Sunday of the week that contains the 1st
    final startOffset = first.weekday % 7; // Sun=0, Mon=1 ... Sat=6
    final start = first.subtract(Duration(days: startOffset));
    return List.generate(42, (i) => start.add(Duration(days: i)));
  }

  // ── Time Slots ──
  final List<TimeSlot> morningSlots = const [
    TimeSlot('8:00 AM'),
    TimeSlot('10:00 AM'),
    TimeSlot('12:00 PM'),
  ];

  final List<TimeSlot> afternoonSlots = const [
    TimeSlot('2:00 PM'),
    TimeSlot('4:00 PM'),
    TimeSlot('6:00 PM'),
  ];

  final Rx<TimeSlot?> selectedSlot = Rx<TimeSlot?>(null);

  void selectSlot(TimeSlot slot) {
    selectedSlot.value = slot;
  }

  bool isSlotSelected(TimeSlot slot) => selectedSlot.value?.label == slot.label;

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
