# Implementation Plan - Caregiver Earnings List

Integrate the real-time earnings list into the "Recent Transactions" section of the Earning screen.

## Proposed Changes

### [API Endpoints]

#### [MODIFY] [app_api_end_point.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/constant/app_api_end_point.dart)
- Add `static const String earnings = "/earnings/me";`

### [Repository]

#### [MODIFY] [caregiver_repository.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/repositories/caregiver_repository.dart)
- Add `getEarnings()` method to fetch the list of earnings.

### [Earning Screen]

#### [MODIFY] [earning_screen_controller.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/care_giver_screens/earning_screen/controller/earning_screen_controller.dart)
- Change `transactions` from a static list to `RxList<EarningTransaction>`.
- Implement `fetchEarnings()` to call `CaregiverRepository.instance.getEarnings()`.
- Map the API response to `EarningTransaction` objects:
    - `title`: "Home Visit - [Client Name]"
    - `subtitle`: "[Formatted Date] . [Duration]h [Service Name]"
    - `amount`: The earning amount.
    - `status`: The earning status (e.g., PENDING, PAID).
- Implement date formatting and duration calculation (if possible from start/end times).

#### [MODIFY] [earning_screen.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/care_giver_screens/earning_screen/earning_screen.dart)
- Ensure the transaction list is wrapped in `Obx`.
- Show a placeholder or empty state if no transactions are found.

## Verification Plan

### Manual Verification
1.  Navigate to the "Earning" tab as a caregiver.
2.  Verify that "Recent Transactions" displays the live data from the API.
3.  Check if the title, date, duration, and service name are correctly formatted.
4.  Verify that the transaction status (Pending/Completed) matches the API data.
