# Implementation Plan - Disable Past Dates in Calendar

Prevent users from selecting dates before the current date on the "Book Caregiver" screen and improve the calendar's visual feedback for disabled dates.

## User Review Required

> [!NOTE]
> Past dates will be greyed out and non-clickable in the calendar to prevent invalid booking attempts.

## Proposed Changes

### [Widgets]

#### [MODIFY] [app_calendar_controller.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/widgets/app_calendar_controller.dart)
- Add `bool isPast(DateTime d)` method to the `AppCalendarController` mixin.
- Implementation: Check if the given date is before today (ignoring time).

#### [MODIFY] [app_calendar.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/widgets/app_calendar.dart)
- Update the `itemBuilder` in the days grid:
    - Check if the date `isPast` using the controller.
    - Disable `onTap` if the date is in the past.
    - Style past dates with a lighter/greyed-out color (`colors.textGrey.withAlpha(50)`).

### [Controllers]

#### [MODIFY] [book_caregiver_controller.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/client_screen/book_caregiver_screen/controller/book_caregiver_controller.dart)
- Add a safety check in `selectDay` to ignore past dates if they are somehow triggered.

## Verification Plan

### Manual Verification
1.  Open the "Book Caregiver" screen.
2.  Navigate to the calendar.
3.  Verify that all dates before today are greyed out.
4.  Try tapping a past date and verify that nothing happens (no API call, no selection change).
5.  Verify that today and future dates are still selectable.
