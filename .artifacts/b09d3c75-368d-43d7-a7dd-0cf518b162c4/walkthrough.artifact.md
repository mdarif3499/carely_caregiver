# Walkthrough - Token Persistence and Automatic Auth Headers

I have implemented the logic to persist the authentication token and user information, and automatically include them in all subsequent API calls.

## Changes Made

### Automatic Authentication Headers
- **Auth Interceptor:** Created [auth_interceptor.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/services/api/auth_interceptor.dart). This interceptor automatically reads the stored token from `SharedPreferences` and adds it to the `Authorization` header as a Bearer token for every request.
- **Service Integration:** Updated [DioApiClient](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/services/api/api_service.dart) to include the `AuthInterceptor` in its Dio instance.

### Data Persistence
- **OTP Verification:** Updated [OtpVerificationController](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/auth_all_screens/otp_verification_screen/controller/otp_verification_controller.dart) to extract and save the `accessToken`, `userId`, `email`, and `role` to `SharedPreferences` upon successful verification.
- **Login:** Updated [LoginScreenController](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/auth_all_screens/login_screen/controller/login_screen_controller.dart) to also persist the same information after a successful login. It also now dynamically determines the `isClient` argument for navigation based on the user's actual role.

## Verification
- Once you log in or verify your OTP, the debug console (Pretty Logger) will show the `Authorization: Bearer <token>` header in all future API requests.
- You no longer need to manually pass tokens to your API methods.

> [!IMPORTANT]
> The `accessToken` and user data are now securely managed across app restarts via `SharePrefsHelper`.
