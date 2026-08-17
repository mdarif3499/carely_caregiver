# Implementation Plan - Login API Integration

This plan details the integration of the Login API into the `LoginScreenController`, following the existing patterns in the codebase (similar to OTP verification) and ensuring proper navigation based on the user's profile status.

## User Review Required

> [!IMPORTANT]
> I will implement the logic to check `intakeCompleted` from the API response.
> - If `true`, the user will navigate to the main dashboard (`appNavigationScreen`).
> - If `false`, the user will be redirected to the profile setup (`basicInfoScreen`) to complete their information.
> This ensures that users who haven't finished their profile are prompted to do so upon login.

## Proposed Changes

### [Component] Authentication Flow

#### [MODIFY] [login_screen_controller.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/auth_all_screens/login_screen/controller/login_screen_controller.dart)
- Update `loginUser()` to:
    - Extract `accessToken`, `refreshToken`, and `user` data from the response.
    - Save all user details (`id`, `email`, `role`, `phone`) to `SharedPreferences` for consistency.
    - Implement conditional navigation:
        - If `user['intakeCompleted'] == true`: Navigate to `AppRoutes.instance.appNavigationScreen`.
        - Otherwise: Navigate to `AppRoutes.instance.basicInfoScreen` and pass user data (`isClient`, `email`, `name`, `phone`) as arguments.
- Ensure the `isLoading` state and snackbars are handled correctly.

## Verification Plan

### Manual Verification
1.  **New User Login:** Login with an account that has `intakeCompleted: false`. Verify redirection to `BasicInfoScreen` with pre-filled data.
2.  **Returning User Login:** Login with an account that has `intakeCompleted: true`. Verify redirection directly to the home/dashboard screen.
3.  **Error Handling:** Try logging in with invalid credentials and verify that an error snackbar is shown.
4.  **Storage Check:** Verify that the token and user info are correctly saved in `SharedPreferences` after a successful login.
