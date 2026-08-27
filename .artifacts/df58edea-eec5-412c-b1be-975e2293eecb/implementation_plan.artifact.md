# Implementation Plan - Auth Flow Skeletonizer and Scaling

I will implement **Skeletonizer** for professional loading states and **responsive scaling** across the entire authentication flow. This includes Login, Sign Up, Forgot Password, OTP, and Role Selection screens.

## User Review Required

> [!IMPORTANT]
> I will be wrapping the main forms in `Skeletonizer` widgets. During API calls (`isLoading == true`), the forms will show a shimmering effect instead of just a loading spinner on the button.

## Proposed Changes

### [Authentication Flow]

I will systematically update the following screens:

#### 1. Login & Sign Up
- **[MODIFY] [login_screen.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/auth_all_screens/login_screen/login_screen.dart)**
    - Wrap the entire body in `Skeletonizer`.
    - Apply responsive scaling to logo, text, and inputs.
- **[MODIFY] [sign_up_screen.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/auth_all_screens/sign_up_screen/sign_up_screen.dart)**
    - Wrap the form in `Skeletonizer`.
    - Apply responsive scaling.

#### 2. Forgot Password Flow
- **[MODIFY] [forgot_email_input_screen.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/auth_all_screens/forgot_screen/screens/forgot_email_input_screen.dart)**
- **[MODIFY] [forgot_otp_input_screen.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/auth_all_screens/forgot_screen/screens/forgot_otp_input_screen.dart)**
- **[MODIFY] [forgot_screen_create_password_screen.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/auth_all_screens/forgot_screen/screens/forgot_screen_create_password_screen.dart)**
    - Apply shimmering and scaling to the multi-step reset flow.

#### 3. Verification & Security
- **[MODIFY] [otp_verification_screen.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/auth_all_screens/otp_verification_screen/otp_verification_screen.dart)**
- **[MODIFY] [change_password_screen.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/auth_all_screens/change_password_screen/change_password_screen.dart)**
    - Professional shimmering for OTP input and password fields.

#### 4. Role Selection (Welcome)
- **[MODIFY] [welcome_screen.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/auth_all_screens/welcome_screen/welcome_screen.dart)**
    - Scale role cards and add shimmering during initial setup navigation.

## Verification Plan

### Automated Tests
- Run `analyze_file` on all modified files to ensure `Skeletonizer` and `flutter_screenutil` extensions are used correctly without compilation errors.

### Manual Verification
- Test the Login/Signup flow and observe the shimmering effect during submission.
- Verify UI proportions on various screen sizes (using different emulators).
- Ensure that text fields remain clickable and accessible after scaling.
