# Implementation Plan - OTP Verification Update

Update the OTP verification flow to support 6-digit codes and integrate the `/auth/verify-email` API.

## Proposed Changes

### [Component] API Constants

#### [MODIFY] [app_api_end_point.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/constant/app_api_end_point.dart)
- Add `verifyEmail` endpoint: `/auth/verify-email`.

### [Component] OTP Verification Controller

#### [MODIFY] [otp_verification_controller.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/auth_all_screens/otp_verification_screen/controller/otp_verification_controller.dart)
- Update `checkOtpFunction` validation to require 6 digits.
- Implement the POST request to `/auth/verify-email` with the required body: `{"email": "...", "otp": ...}`.
- Parse OTP as an integer for the API call as per the provided documentation.

### [Component] OTP Verification Screen

#### [MODIFY] [otp_verification_screen.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/auth_all_screens/otp_verification_screen/otp_verification_screen.dart)
- Update instruction text to "6-digit code".
- Change `MaterialPinField` `length` to 6.
- Adjust `cellSize` and `spacing` of `MaterialPinField` to ensure 6 boxes fit on the screen without overflow.

## Verification Plan

### Manual Verification
- Navigate to the OTP screen.
- Verify that 6 input boxes are displayed.
- Enter a 6-digit code and click "Verify".
- Check the console logs (Pretty Logger) to ensure the request is sent to `/auth/verify-email` with the correct body.
- Verify that the success dialog appears and navigates to Login on a successful API response.
- Verify error snackbars appear for invalid OTPs.
