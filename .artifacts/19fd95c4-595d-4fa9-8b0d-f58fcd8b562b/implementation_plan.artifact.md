# Implementation Plan - Multi-Role Profile Setup & API Integration

This plan covers redesigning the profile setup screens for Caregivers and Clients based on the provided screenshots, and integrating the `care-recipient` API for the Client flow.

## User Review Required

> [!IMPORTANT]
> The Postman screenshot for `/care-recipient` includes many fields (DOB, Gender, Primary Language, etc.). However, following your instruction ("sob lagbe na uite za ache only oigulai"), I will **only** include the fields that are present in the UI screenshot: `Recipient Full Name`, `Your Relationship`, and `Health Considerations & Care Needs`.

> [!NOTE]
> The profile photo picker was requested to be removed from the `NewRecipientProfileScreen` in the previous turn. I will stick to that and exclude it from both the UI and the API integration for this screen.

## Proposed Changes

### [Component] Routing & Navigation

#### [MODIFY] [basic_info_controller.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/profile_screens/basic_info_screen/controller/basic_info_controller.dart)
- Update the navigation logic in `updateProfile` success block:
    - `isClient == true` -> Navigate to `AppRoutes.instance.newRecipientProfileScreen`
    - `isClient == false` -> Navigate to `AppRoutes.instance.profileSetUpScreen`

---

### [Component] API Integration

#### [MODIFY] [app_api_end_point.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/constant/app_api_end_point.dart)
- Add `static const String createCareRecipient = "/care-recipient";`

#### [NEW] [client_repository.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/repositories/client_repository.dart)
- Implement `createCareRecipient` to handle the POST request for creating a new recipient.

---

### [Component] Caregiver UI (Professional Details)

#### [MODIFY] [profile_setup_screen.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/profile_screens/profile_setup_screen/profile_setup_screen.dart)
- Redesign the layout to match **Screenshot 1**.
- Add a "Back" button next to "Continue" at the bottom.
- Ensure sections for Skills, Work Experience, and Certifications follow the design.

---

### [Component] Client UI (Who are you seeking care for?)

#### [MODIFY] [new_recipient_profile_screen.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/client_screen/new_recipient_profile_screen/new_recipient_profile_screen.dart)
- Redesign the layout to match **Screenshot 2**.
- Center the header "Who are you seeking care for?".
- Implement the form with `Recipient Full Name`, `Your Relationship` (Dropdown), and `Health Considerations & Care Needs` (Multiline TextField).
- Add "Back" and "Continue" buttons at the bottom.
- Ensure all fields use the light lavender background (`textFiledBg`).

#### [MODIFY] [health_profile_controller.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/client_screen/new_recipient_profile_screen/controller/health_profile_controller.dart)
- Update text controllers and observable variables to match the new UI.
- Implement `saveRecipient` to call `ClientRepository.createCareRecipient` with the UI data.
- Map "Health Considerations" to the `medicalConditions` field in the API.

## Verification Plan

### Manual Verification
1.  Complete `BasicInfoScreen` as a Client -> Verify navigation to the new `NewRecipientProfileScreen`.
2.  Fill in the client details -> Click "Continue" -> Verify successful API call to `/care-recipient` with correct payload.
3.  Complete `BasicInfoScreen` as a Caregiver -> Verify navigation to "Professional Details".
4.  Verify the "Back" buttons on both screens return the user to the `BasicInfoScreen`.
