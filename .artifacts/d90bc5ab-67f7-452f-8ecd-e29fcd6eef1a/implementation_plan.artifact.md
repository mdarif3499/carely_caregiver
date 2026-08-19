# Implementation Plan - Professional "Add Shift" UI and API Integration

Revamp the "Add Shift" functionality in the `AvailabilityScreen` to provide a premium, professional user experience and integrate with the backend API.

## User Review Required

> [!IMPORTANT]
> - I will be adding a new `availability` endpoint to `AppApiEndPoint`.
> - The "Add Shift" UI will be implemented as a modern bottom sheet with custom shift type selection and time pickers.
> - `shiftType` will be restricted to `MORNING`, `AFTERNOON`, and `EVENING` as per the API requirements.

## Proposed Changes

### [Constants & API]

#### [MODIFY] [app_api_end_point.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/constant/app_api_end_point.dart)
- Add `static const String availability = "/availability";`.

#### [MODIFY] [caregiver_repository.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/repositories/caregiver_repository.dart)
- Add `addAvailability` method to handle the POST request to `/availability`.

### [Controller Layer]

#### [MODIFY] [availability_screen_controller.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/care_giver_screens/availability_screen/controller/availability_screen_controller.dart)
- Update `Shift` model (if needed) or create a mapper to API format.
- Add `saveShift` method that calls the repository.
- Implement loading states during API calls.

### [UI Layer]

#### [MODIFY] [availability_screen.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/care_giver_screens/availability_screen/availability_screen.dart)
- Completely redesign `_showAddShiftSheet` to be a professional, premium bottom sheet.
- Implement custom shift type selector with icons and modern styling.
- Use a professional time picker UI for selecting start and end times.
- Add validation to ensure `endTime` is after `startTime`.

#### [MODIFY] [availability_widgets.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/care_giver_screens/availability_screen/widget/availability_widgets.dart)
- Add or update widgets needed for the premium "Add Shift" experience.

## Verification Plan

### Manual Verification
1. Open the **Availability** screen.
2. Tap **+ Add Shift**.
3. Verify the new premium UI for selecting shift type and times.
4. Try saving a shift and verify it calls the API (mocked or real) with the correct JSON body format.
5. Verify that `startTime` and `endTime` are formatted as `HH:mm`.
6. Verify that `date` is formatted as `YYYY-MM-DD`.
