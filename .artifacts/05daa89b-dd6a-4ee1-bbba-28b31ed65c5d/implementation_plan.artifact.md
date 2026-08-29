# Implementation Plan - Booking Decline Logic & UI

Update the booking decline flow to require a reason and show the decline option based on payment status.

## User Review Required

> [!IMPORTANT]
> - The "Decline" button will now be visible whenever the **Payment Status is Unpaid**.
> - Declining a booking now strictly requires a reason. A dialog with a text field will appear to collect this.

## Proposed Changes

### [Repository]

#### [MODIFY] [caregiver_repository.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/repositories/caregiver_repository.dart)
- Update `declineBooking(String id, String reason)` to send `{"declineReason": reason}` in the request body.

### [Booking Details Screen]

#### [MODIFY] [booking_details_controller.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/care_giver_screens/booking_details_screen/controller/booking_details_controller.dart)
- Add `TextEditingController declineReasonController`.
- Implement `showDeclineDialog()`:
    - Opens a `Get.dialog` with a professional design.
    - Includes a `TextField` for the reason.
    - Validates that the reason is not empty before calling the API.
- Update `decline(String reason)` to pass the reason to the repository and refresh the UI upon success.

#### [MODIFY] [booking_details_widgets.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/care_giver_screens/booking_details_screen/widgets/booking_details_widgets.dart)
- Update `BookingDetailActions` visibility logic:
    - Show the "Decline" button if `booking.paymentStatus == 'UNPAID'`.
    - Ensure it triggers `controller.showDeclineDialog()` on click.

## Verification Plan

### Manual Verification
1.  **Visibility**: Open an unpaid booking. Verify the "Decline" button is visible.
2.  **Dialog**: Click "Decline". Verify a popup appears with a text field.
3.  **Validation**: Try to submit without a reason. Verify it doesn't call the API.
4.  **Success**: Enter a valid reason and submit. Verify the API call is successful and the screen reloads.
