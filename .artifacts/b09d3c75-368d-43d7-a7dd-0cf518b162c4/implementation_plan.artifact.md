# Implementation Plan - Fix Logout Logic

The current logout functionality only navigates to the login screen without clearing the session data from `SharedPreferences`. This causes the splash screen to automatically redirect back to the dashboard on app restart. This plan ensures that all session data is cleared upon logout.

## Proposed Changes

### [Component] Profile Screen Logic

#### [MODIFY] [profile_screen_controller.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/profile_screens/profile_screen/controller/profile_screen_controller.dart)
- Import `SharePrefsHelper`.
- Update the `logout()` method to call `SharePrefsHelper.clearData()` before navigating to the login screen.

### [Component] Utilities

#### [MODIFY] [share_pref_helper.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/services/share_pref_helper/share_pref_helper.dart)
- Update `clearData()` to also remove `email` to ensure a complete session cleanup.

## Verification Plan

### Manual Verification
1.  Open the app and ensure you are logged in (or log in).
2.  Navigate to the Profile screen.
3.  Click the "Logout" button.
4.  Verify that you are taken to the Login screen.
5.  Close the app completely (kill the process).
6.  Reopen the app.
7.  **Expected:** The splash screen should redirect you to the **Login screen**, not the dashboard.
