# Implementation Plan - Token Persistence and Automatic Auth Headers

Persist the `accessToken` and user information from the OTP verification response to `SharedPreferences` and ensure all subsequent API calls automatically include the Bearer token.

## Proposed Changes

### [Component] API Service Layer
Add an interceptor to automatically inject the stored token into outgoing requests.

#### [NEW] [auth_interceptor.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/services/api/auth_interceptor.dart)
- Create `AuthInterceptor` extending `InterceptorsWrapper`.
- In `onRequest`, fetch the token from `SharePrefsHelper`.
- If a token exists, add it to the `Authorization` header: `Bearer <token>`.

#### [MODIFY] [api_service.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/services/api/api_service.dart)
- Import `AuthInterceptor`.
- Add `AuthInterceptor()` to the `Dio` interceptors list.

### [Component] Controllers
Handle successful responses by persisting data.

#### [MODIFY] [otp_verification_controller.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/auth_all_screens/otp_verification_screen/controller/otp_verification_controller.dart)
- In `checkOtpFunction`, upon success:
    - Extract `accessToken` from `response.data['data']`.
    - Extract user info (`id`, `email`, `role`) from `response.data['data']['user']`.
    - Save these values using `SharePrefsHelper`.

## Verification Plan

### Manual Verification
- Complete the registration and OTP verification flow.
- Verify that the console logs show the successful verification.
- Trigger another API call (like fetching a profile, if available) or check the next API request logs.
- **Expected:** Every subsequent request in the debug console (Pretty Logger) should now contain the `Authorization: Bearer <token>` header.
- Restart the app and verify that the session persists (if logic allows).
