# Implementation Plan - Professional Automatic Logout on Session Expired

The goal is to implement a professional and robust automatic logout mechanism when the API returns a "Session Expired" error or a 401 Unauthorized status code.

## User Review Required

> [!IMPORTANT]
> The app will now automatically redirect the user to the Login screen if their session expires or if the server rejects their token (401 Unauthorized). All local user data will be cleared securely during this process.

## Proposed Changes

### [Network Service]

#### [MODIFY] [auth_interceptor.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/services/api/auth_interceptor.dart)
- Enhance the logout detection logic in both `onResponse` and `onError`.
- **Check for 401 Status Code**: Standard professional behavior is to logout on any 401 error.
- **Robust Message Matching**: Check for "Session Expired" in a case-insensitive manner to handle slight variations from the backend.
- **Synchronized Logout**: Ensure `SharePrefsHelper.clearData()` is fully awaited before navigating.
- **Improved User Feedback**: Use a slight delay before navigation so the "Session Expired" snackbar is actually visible to the user.

### [Data Persistence]

#### [MODIFY] [share_pref_helper.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/services/share_pref_helper/share_pref_helper.dart)
- Ensure `clearData()` properly handles all keys that should be wiped on logout to prevent state leakage between sessions.

## Verification Plan

### Manual Verification
1. **Mock Session Expiry**: Temporarily modify the interceptor to trigger logout on a specific response or status code.
2. **Verify Navigation**: Ensure the app navigates to `LoginScreen` and clears the navigation stack (`offAllNamed`).
3. **Verify Data Wipe**: Check that `SharedPreferences` are empty after the automatic logout.
4. **Verify Connectivity**: Ensure the Socket is disconnected (handled in `clearData`).
