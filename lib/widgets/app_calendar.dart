import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:carely_caregiver/widgets/app_calendar_controller.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AppCalendar extends StatelessWidget {
  final AppCalendarController controller;

  const AppCalendar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;

    return Column(
      children: [
        // ── Header (Month + Arrows) ───────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: controller.previousMonth,
                icon: Icon(Icons.chevron_left, color: colors.textPrimary),
              ),
              Obx(() => CommonText(
                    text: DateFormat('MMMM yyyy').format(controller.focusedMonth.value),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    textColor: colors.textPrimary,
                  )),
              IconButton(
                onPressed: controller.nextMonth,
                icon: Icon(Icons.chevron_right, color: colors.textPrimary),
              ),
            ],
          ),
        ),

        // ── Weekdays Header ───────────────────────────
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                .map((day) => Expanded(
                      child: Center(
                        child: CommonText(
                          text: day,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          textColor: colors.secondaryText,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),

        // ── Days Grid ─────────────────────────────────
        Obx(() {
          final days = controller.calendarDays;
          final focusedMonth = controller.focusedMonth.value.month;

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: days.length,
            itemBuilder: (context, index) {
              final date = days[index];
              final isSelected = controller.isSelected(date);
              final isToday = controller.isToday(date);
              final isPast = controller.isPast(date);
              final isCurrentMonth = date.month == focusedMonth;

              return GestureDetector(
                onTap: isPast ? null : () => controller.selectDay(date),
                behavior: HitTestBehavior.opaque,
                child: Center(
                  child: Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? colors.primary
                          : Colors.transparent,
                      border: isToday && !isSelected
                          ? Border.all(color: colors.primary, width: 1.5)
                          : null,
                    ),
                    child: CommonText(
                      text: date.day.toString(),
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      textColor: isSelected
                          ? colors.white
                          : (isPast 
                              ? colors.textGrey.withAlpha(50) 
                              : (isCurrentMonth
                                  ? colors.textPrimary
                                  : colors.textGrey.withAlpha(100))),
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ],
    );
  }
}
