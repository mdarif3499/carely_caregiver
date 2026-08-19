# Implementation Plan - Fix Navigation Focus & Disposal Crash

The issue is caused by a race condition: when navigating away from a screen (using `Get.offAllNamed`), the controller is disposed immediately, but the UI widgets (like `CommonTextField`) are still present for a short time during the transition. When these widgets lose focus, their internal listeners attempt to access the already-disposed `TextEditingController`, leading to the crash.

## Proposed Changes

### [Component] Authentication Controllers

#### [MODIFY] [login_screen_controller.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/auth_all_screens/login_screen/controller/login_screen_controller.dart)
- Add `FocusManager.instance.primaryFocus?.unfocus();` before any navigation call (`Get.offAllNamed`, `Get.toNamed`) that results in controller disposal. This ensures focus listeners fire while controllers are still alive.
- Retain the `if (!isClosed)` guards as a secondary layer of defense.

#### [MODIFY] [forgot_screen_controller.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/auth_all_screens/forgot_screen/controller/forgot_screen_controller.dart)
- Add `FocusManager.instance.primaryFocus?.unfocus();` before `Get.offAllNamed(AppRoutes.instance.loginScreen)`.

#### [MODIFY] [otp_verification_controller.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/auth_all_screens/otp_verification_screen/controller/otp_verification_controller.dart)
- (Safety Check) Ensure `onSuccess()` calls in the UI are also preceded by an unfocus if they trigger navigation.

## Verification Plan

### Manual Verification
1.  **Forgot to Login Transition:** Navigate from Forgot Password -> OTP -> Create Password -> Success -> Login. Verify no crash occurs during the final transition.
2.  **Keyboard Open Navigation:** Start typing in a field and trigger a successful submission (Login or Reset). Verify that the keyboard hides and the navigation happens smoothly without disposal errors.
3.  **Stress Test:** Rapidly trigger navigation multiple times to ensure the `FocusManager` cleanup and `isClosed` guards work together to prevent race conditions.
