import 'package:get/get.dart';

mixin AppCalendarController {
  Rx<DateTime> get focusedMonth;
  Rx<DateTime> get selectedDay;
  List<DateTime> get calendarDays;
  
  void previousMonth();
  void nextMonth();
  void selectDay(DateTime day);
  bool isSelected(DateTime d);
  bool isToday(DateTime d);
}
