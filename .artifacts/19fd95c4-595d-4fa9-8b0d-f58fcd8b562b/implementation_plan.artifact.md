# Implementation Plan - Forgot Password Flow Integration

The goal is to complete the forgot password flow by capturing the `resetToken` from the OTP verification response and using it to reset the password in the final step.

## Proposed Changes

### [Component] API Integration Layer

#### [MODIFY] [app_api_end_point.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/constant/app_api_end_point.dart)
- Add `static const String resetPassword = "/auth/reset-password";`

#### [MODIFY] [auth_repository.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/repositories/auth_repository.dart)
- Implement `resetPassword` method to handle the final password update POST request.
- This method will accept `newPassword`, `confirmPassword`, and the `resetToken`.

---

### [Component] Forgot Password Logic

#### [MODIFY] [forgot_screen_controller.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/auth_all_screens/forgot_screen/controller/forgot_screen_controller.dart)
- **State:** Add a `String resetToken = "";` to store the token received from the OTP verification success response.
- **OTP Verification:** Update `checkOtpFunction` to:
    - Extract `resetToken` from `response.data['data']['resetToken']`.
    - Store it in the controller.
    - Navigate to the "Create Password" step on the `PageView`.
- **Password Reset:** Refactor `checkCreateFunction` to be `async` and:
    - Validate the form.
    - Call `AuthRepository.instance.resetPassword` with the new passwords and stored `resetToken`.
    - On success, show a snackbar and navigate to the login screen.
    - Handle loading states correctly.

---

### [Component] UI Enhancements

#### [MODIFY] [forgot_screen_create_password_screen.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/auth_all_screens/forgot_screen/screens/forgot_screen_create_password_screen.dart)
- Wrap the "Update Password" button in an `Obx` to show the loading indicator when `controller.isLoading` is true.

## Verification Plan

### Manual Verification
1.  **Request OTP:** Enter an email in the forgot password screen and verify OTP is sent.
2.  **Verify OTP:** Enter the correct OTP and verify the app moves to the "Create Password" screen (and the `resetToken` is captured in logs).
3.  **Reset Password:** Enter a new password and confirm it.
4.  **Success:** Verify that clicking "Update Password" calls the API and redirects to the Login screen with a success message.
5.  **Error States:** Verify that invalid OTPs or failed password resets (e.g., mismatch) show appropriate error snackbars.
