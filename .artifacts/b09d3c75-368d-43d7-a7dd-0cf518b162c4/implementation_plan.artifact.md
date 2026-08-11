# Implementation Plan - Final Audit and Fixes for Auth Flow

Ensure all authentication screens (Login, Signup, OTP, Forgot Password) are bug-free, professional, and consistent with the requested `MaterialPinField` and API integrations.

## User Review Required

> [!IMPORTANT]
> I will standardize the OTP length to 6 digits across all OTP screens (Registration and Forgot Password) as per the latest API requirements.

## Proposed Changes

### [Component] Authentication Screens

#### [MODIFY] [otp_verification_controller.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/auth_all_screens/otp_verification_screen/controller/otp_verification_controller.dart)
- Set timer to exactly 4 minutes (240 seconds).
- Ensure `isLoading` is used correctly in the UI.
- Add descriptive logs for API calls.

#### [MODIFY] [otp_verification_screen.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/auth_all_screens/otp_verification_screen/otp_verification_screen.dart)
- Ensure no duplicate `Positioned` or layout issues.
- Clean up unused imports.

#### [MODIFY] [forgot_otp_input_screen.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/auth_all_screens/forgot_screen/screens/forgot_otp_input_screen.dart)
- Update `MaterialPinField` to have `length: 6`.
- Add `onCompleted` callback to trigger the API call automatically.
- Adjust `cellSize` and `spacing` for 6 digits.

#### [MODIFY] [forgot_screen_controller.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/auth_all_screens/forgot_screen/controller/forgot_screen_controller.dart)
- Update `checkOtpFunction` to require 6 digits.
- Ensure API call to `verifyEmail` is correctly implemented.

## Verification Plan

### Manual Verification
- Test Registration OTP: Enter 6 digits and verify it calls the API and shows the success dialog.
- Test Forgot Password OTP: Enter 6 digits and verify it navigates to the Create Password step.
- Verify no "disposed controller" errors occur when navigating between these screens.
