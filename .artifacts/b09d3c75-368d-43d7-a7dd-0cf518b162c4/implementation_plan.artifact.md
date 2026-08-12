# Implementation Plan - Professional Profile Update Integration

Implement the professional profile update functionality using the `/user/my-profile` (PATCH) endpoint with multipart/form-data support.

## Proposed Changes

### [Component] API Service Layer
Extend the API layer to support multipart (form-data) requests required for uploading profile images.

#### [MODIFY] [api_client.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/services/api/api_client.dart)
- Add `multipart` method definition to the interface.

#### [MODIFY] [api_service.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/services/api/api_service.dart)
- Implement the `multipart` method using `Dio`'s `FormData`.

### [Component] Constants
Add the new endpoint.

#### [MODIFY] [app_api_end_point.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/constant/app_api_end_point.dart)
- Add `updateProfile = "/user/my-profile"`.

### [Component] Data Layer (Repository)
Create a repository to handle user-related operations.

#### [NEW] [user_repository.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/repositories/user_repository.dart)
- Implement `updateProfile` method which accepts name, phone, intakeCompleted, and an optional image file.

### [Component] Profile Screen Logic

#### [MODIFY] [basic_info_controller.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/profile_screens/basic_info_screen/controller/basic_info_controller.dart)
- Add a variable to store the selected profile image file.
- Implement `updateProfile()` method:
    - Capture data from controllers.
    - Call `UserRepository.updateProfile`.
    - Handle loading state and navigation upon success.

#### [MODIFY] [basic_info_screen.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/profile_screens/basic_info_screen/basic_info_screen.dart)
- Update `AppImagePicker` to pass the selected file to the controller via `onSaved`.
- Bind the "Continue" / "Next Step" buttons to `controller.updateProfile()`.

## Verification Plan

### Manual Verification
- Register a new user and verify OTP.
- In `BasicInfoScreen`, change the name/phone and select a profile photo.
- Click "Next Step" / "Continue".
- Verify (via debug console logs) that a `PATCH` request is sent to `/user/my-profile` with `multipart/form-data`.
- Confirm that the response is successful and the app proceeds to the next screen.
