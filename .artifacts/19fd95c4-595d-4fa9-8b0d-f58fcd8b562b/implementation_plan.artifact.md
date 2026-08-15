# Implementation Plan - Multi-Role Profile Setup Flow

The goal is to implement a role-based navigation flow after the `BasicInfoScreen` success. Depending on the user's role, they will be directed to either a "Professional Details" screen (Caregiver) or a "Who are you seeking care for?" screen (Client), matching the provided screenshots.

## Proposed Changes

### [Component] Navigation Flow

#### [MODIFY] [basic_info_controller.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/profile_screens/basic_info_screen/controller/basic_info_controller.dart)
- Update `updateProfile` success logic:
    - If `isClient` is true: Navigate to `AppRoutes.instance.newRecipientProfileScreen`.
    - If `isClient` is false (Caregiver): Navigate to `AppRoutes.instance.profileSetUpScreen`.

---

### [Component] Caregiver Profile Setup (Professional Details)

#### [MODIFY] [profile_setup_screen.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/profile_screens/profile_setup_screen/profile_setup_screen.dart)
- Match Screenshot 1:
    - Update `_buildBottomButtons` to include a "Back" button next to "Continue".
    - Ensure the layout and spacing match the "Professional Details" design.
    - Verify "Skills & Specializations", "Work Experience", and "Certifications & Licenses" sections are correctly styled.

---

### [Component] Client Profile Setup (Recipient Info)

#### [MODIFY] [new_recipient_profile_screen.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/client_screen/new_recipient_profile_screen/new_recipient_profile_screen.dart)
- Redesign to match Screenshot 2:
    - **Header:** Update to "Who are you seeking care for?" with the corresponding subtext.
    - **Photo Picker:** Implement a circular photo picker with a dashed border, similar to `BasicInfoScreen`.
    - **Fields:**
        - "Recipient Full Name" (TextField)
        - "Your Relationship" (Dropdown with options: Parent, Spouse, Sibling, Friend, Other)
        - "Health Considerations & Care Needs" (Multiline TextField)
    - **Buttons:** Update the bottom area to have "Back" and "Continue" side-by-side.

#### [MODIFY] [health_profile_controller.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/client_screen/new_recipient_profile_screen/controller/health_profile_controller.dart)
- Update controllers and state to match the new fields:
    - `recipientNameController`
    - `relationshipController` / `selectedRelationship`
    - `healthNeedsController`
    - `profileImage` (File?)

## Verification Plan

### Manual Verification
- **Caregiver Flow:**
    - Log in as a Caregiver.
    - Complete `BasicInfoScreen`.
    - Verify navigation to "Professional Details".
    - Verify the UI matches Screenshot 1.
- **Client Flow:**
    - Log in as a Client.
    - Complete `BasicInfoScreen`.
    - Verify navigation to "Who are you seeking care for?".
    - Verify the UI matches Screenshot 2.
- **Interactions:**
    - Test the "Back" buttons on both screens.
    - Test the photo picker on the Client screen.
    - Verify data can be entered in all fields.
