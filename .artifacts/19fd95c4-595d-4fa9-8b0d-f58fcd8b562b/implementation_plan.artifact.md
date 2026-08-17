# Implementation Plan - Dynamic Home Header Integration

The goal is to replace the hardcoded "Jane Cooper" and static avatars in the Home headers with real data fetched from the `{{base_url}}/user/my-profile` API.

## Proposed Changes

### [Component] Home Controllers

#### [MODIFY] [care_giver_home_controller.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/care_giver_screens/care_giver_home_screen/controller/care_giver_home_controller.dart)
- Remove hardcoded `userName` and `userAvatarUrl`.
- Add a reference to `AppNavigationScreenController` to access the loaded profile.

#### [MODIFY] [client_home_controller.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/client_screen/controller/client_home_controller.dart)
- Remove hardcoded `userName` and `userAvatarUrl`.
- Add a reference to `AppNavigationScreenController`.

---

### [Component] Home Screens UI

#### [MODIFY] [care_giver_home_screen.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/care_giver_screens/care_giver_home_screen/care_giver_home_screen.dart)
- Access `AppNavigationScreenController` to pass real user data to the `CareGiverHeader`.
- Wrap the `CareGiverHeader` in an `Obx` to ensure it updates when the profile finishes loading.

#### [MODIFY] [client_home_screen.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/client_screen/client_home_screen.dart)
- Access `AppNavigationScreenController` to pass real user data to the `ClientHomeHeader`.
- Wrap the `ClientHomeHeader` in an `Obx` for reactive updates.

## Verification Plan

### Manual Verification
1.  **Login:** Log into the app with a valid user.
2.  **Home Header:** Verify that the header shows the correct name (e.g., "dopot") instead of "Jane Cooper".
3.  **Avatar:** Verify that the profile image shows the user's real avatar from the API (if available) or the default placeholder.
4.  **Loading State:** Ensure the app doesn't crash if the profile is still being fetched when the home screen loads.
