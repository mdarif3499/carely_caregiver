# Walkthrough - Caregiver Real-time Earnings List

I have integrated the real-time earnings list into the "Recent Transactions" section of the Earning screen for caregivers.

## Changes Made

### [API & Repository]
- **Endpoint**: Added the `/earnings/me` endpoint to `AppApiEndPoint`.
- **Repository**: Implemented `getEarnings()` in `CaregiverRepository` to fetch the transaction history.

### [Earning Screen]
- **Controller Logic**:
    - Updated `EarningScreenController` to fetch data from the new endpoint.
    - Implemented mapping logic to transform raw API data into `EarningTransaction` objects.
    - Added automatic calculation of session duration (e.g., "2h") based on slot start and end times.
    - Formatted statuses to be user-friendly (e.g., "PAID" becomes "Completed").
- **UI Enhancement**:
    - The transaction list now updates reactively using GetX.
    - Added an empty state message ("No transactions found.") when no data is available.
    - Integrated with the existing `Skeletonizer` for a seamless loading experience.

## Verification Results

### Manual Verification
- **Dynamic Content**: The transaction list correctly shows "Home Visit - [Client Name]" and formatted sub-details.
- **Duration Calculation**: The duration (e.g., "2h") is correctly derived from the start and end times in the booking data.
- **Status Mapping**: Backend statuses like `PENDING` and `PAID` are correctly displayed as "Pending" and "Completed".
- **Empty State**: Verified that the screen handles empty data gracefully.
