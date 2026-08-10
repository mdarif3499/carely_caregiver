# Implementation Plan - Privacy Policy Screen UI Update

Update the `PrivacyPolicyScreen` to match the professional design provided in the screenshot and link it to the Profile screen.

## Proposed Changes

### Privacy Policy Feature

#### [NEW] [privacy_policy_widgets.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/privacy_policy_screen/widgets/privacy_policy_widgets.dart)
- `LastUpdatedBanner`: Light blue card with a calendar icon showing the revision date.
- `PolicySectionHeader`: Reusable header with a blue vertical indicator bar.
- `BulletPointItem`: List item with a small circle bullet and descriptive text.
- `CheckmarkItem`: List item with a purple circular checkmark.
- `SecurityBox`: Dark-themed container for high-priority security information.

#### [MODIFY] [privacy_policy_screen.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/privacy_policy_screen/privacy_policy_screen.dart)
- Re-implement the screen to match the screenshot layout:
    - Header with back button.
    - Intro text ("At CareConnect...").
    - "Information We Collect" section.
    - "How We Use Your Data" section.
    - "Data Security" section.

### Profile Integration

#### [MODIFY] [profile_screen.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/profile_screens/profile_screen/profile_screen.dart)
- Link the "Privacy Policy" menu item to `AppRoutes.instance.privacyPolicy`.

## Verification Plan

### Automated Tests
- Run `fvm flutter analyze` to ensure code integrity and correct routing.

### Manual Verification
- Log in as a user and navigate to **Profile -> Privacy Policy**.
- Verify the layout, icons, and sections match the professional design precisely.
