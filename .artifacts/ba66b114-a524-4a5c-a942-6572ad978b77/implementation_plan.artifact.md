# Implementation Plan - Notification Settings Screen

Implement a new "Notification Settings" screen (referred to as General Preferences in the UI) to allow users to toggle various alert types. This screen will be accessible from the Profile menu.

## Proposed Changes

### Routes & Navigation

#### [MODIFY] [app_routes.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/routes/app_routes.dart)
- Add `notificationSettingsScreen` constant.

#### [MODIFY] [app_routes_file.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/routes/app_routes_file.dart)
- Register `NotificationSettingsScreen` with `NavigationScreenBinding`.

#### [MODIFY] [profile_screen.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/profile_screens/profile_screen/profile_screen.dart)
- Link the "Notifications" menu item to `AppRoutes.instance.notificationSettingsScreen`.

### Notification Settings Feature

#### [NEW] [notification_settings_controller.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/profile_screens/notification_settings_screen/controller/notification_settings_controller.dart)
- Manage toggle states for:
    - Enable Notifications
    - Booking Alerts
    - Payment Alerts
    - Messages

#### [NEW] [notification_settings_widgets.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/profile_screens/notification_settings_screen/widgets/notification_settings_widgets.dart)
- `SettingsToggleTile`: A list item with a soft blue background icon, title, and a `Switch` (toggle).

#### [NEW] [notification_settings_screen.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/profile_screens/notification_settings_screen/notification_settings_screen.dart)
- Main layout using `DefaultBackgroundTemplate`:
    - "Profile" / "General Preferences" header.
    - A card container housing the toggle tiles.

#### [MODIFY] [navigation_screen_binding.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/routes/bindings/navigation_screen_binding.dart)
- Register `NotificationSettingsController`.

## Verification Plan

### Automated Tests
- Run `fvm flutter analyze` to ensure no syntax errors.

### Manual Verification
- Log in and navigate to **Profile -> Notifications**.
- Verify the UI matches the screenshot (card with toggles, icons, spacing).
- Ensure all toggles are functional (UI updates correctly).
- Verify navigation back to the Profile screen.
