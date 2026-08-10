# Implementation Plan - Care Recipients Management Flow

This plan covers the complete implementation of the "Care Recipients" list screen and the "New Care Recipients Profile" (Health Profile) screen for the Client role.

## Proposed Changes

### Routes & Navigation

#### [MODIFY] [app_routes.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/routes/app_routes.dart)
- Add `careRecipientsScreen` and `newRecipientProfileScreen` constants.

#### [MODIFY] [app_routes_file.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/routes/app_routes_file.dart)
- Register both screens with `NavigationScreenBinding`.

#### [MODIFY] [profile_screen.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/profile_screens/profile_screen/profile_screen.dart)
- Link "Care Recipients" menu item to `careRecipientsScreen`.

### Care Recipients List Screen

#### [NEW] [care_recipients_widgets.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/client_screen/care_recipients_screen/widgets/care_recipients_widgets.dart)
- `AddRecipientDashedCard`: Blue dashed border card linking to the creation screen.
- `RecipientListCard`: Professional card with image, details, and service tags.

#### [NEW] [care_recipients_controller.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/client_screen/care_recipients_screen/controller/care_recipients_controller.dart)
- Manage the list of recipients.

#### [NEW] [care_recipients_screen.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/client_screen/care_recipients_screen/care_recipients_screen.dart)
- Main layout for viewing family members.

### New Care Recipient Profile (Health Profile)

#### [NEW] [health_profile_widgets.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/client_screen/new_recipient_profile_screen/widgets/health_profile_widgets.dart)
- `HealthProfilePhotoPicker`: Stylized circular placeholder with plus icon and camera overlay.
- `LanguageSelector`: Row of chips (English, Spanish, Other) with selection state.
- `DateField`: Input field with a calendar icon suffix.

#### [NEW] [health_profile_controller.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/client_screen/new_recipient_profile_screen/controller/health_profile_controller.dart)
- Handle form controllers for Name, DOB, Gender, Language, and Medical Conditions.

#### [NEW] [new_recipient_profile_screen.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/client_screen/new_recipient_profile_screen/new_recipient_profile_screen.dart)
- Comprehensive form UI matching the provided screenshot.

#### [MODIFY] [navigation_screen_binding.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/routes/bindings/navigation_screen_binding.dart)
- Register new controllers.

## Verification Plan

### Automated Tests
- Run `fvm flutter analyze` to ensure code integrity.

### Manual Verification
- Log in as a **Client**.
- Navigate: Profile -> Care Recipients -> Add New Recipient.
- Verify both screens match the typography, spacing, and colors of the screenshots.
- Ensure the "Save Recipient" and "Cancel" actions work correctly.
