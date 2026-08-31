# Implementation Plan - Fix Hero Tag Collisions

Resolve the `multiple heroes that share the same tag` error by ensuring every Hero widget in the app has a unique identifier, even if multiple widgets display the same image.

## User Review Required

> [!IMPORTANT]
> - All profile and chat images will now use context-specific Hero tags (e.g., `header_`, `chat_`, `details_`).
> - This fix ensures the app doesn't crash when navigating between screens that show the same user's profile photo.

## Proposed Changes

### [Core]

#### [MODIFY] [full_screen_image_screen.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/message_screen/full_screen_image_screen.dart)
- Update `build` to handle `Get.arguments` as a `Map<String, String>` containing both `imageUrl` and `heroTag`.
- Use the passed `heroTag` for the `Hero` widget.

### [UI Components]

#### [MODIFY] [care_giver_home_widgets.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/care_giver_screens/care_giver_home_screen/widgets/care_giver_home_widgets.dart)
- Update `CareGiverHeader` to use `tag: 'header_${avatarUrl}'`.
- Update navigation to pass `{ "url": avatarUrl, "tag": 'header_${avatarUrl}' }`.

#### [MODIFY] [client_home_widgets.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/client_screen/widgets/client_home_widgets.dart)
- Update `ClientHomeHeader` to use `tag: 'client_home_header_${avatarUrl}'`.
- Update navigation to pass `{ "url": avatarUrl, "tag": 'client_home_header_${avatarUrl}' }`.

#### [MODIFY] [profile_widgets.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/profile_screens/profile_screen/widgets/profile_widgets.dart)
- Update `ProfileAvatarHeader` to use `tag: 'profile_screen_${avatarUrl}'`.
- Update navigation to pass `{ "url": avatarUrl, "tag": 'profile_screen_${avatarUrl}' }`.

#### [MODIFY] [booking_details_widgets.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/care_giver_screens/booking_details_screen/widgets/booking_details_widgets.dart)
- Update `ClientProfileHeader` to use `tag: 'booking_details_${booking.id}_${booking.avatarUrl}'`.
- Update navigation to pass context-specific tag.

#### [MODIFY] [care_giver_details_screen.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/client_screen/care_giver_details_screen/care_giver_details_screen.dart)
- Update Hero tag to `tag: 'caregiver_profile_details_${profile?.id}_${profile?.profileImage}'`.

#### [MODIFY] [message_screen.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/message_screen/message_screen.dart)
- Update Header Hero to `tag: 'chat_header_${chatId}'`.
- Update Message Bubbles to use `tag: 'chat_msg_${chat.messageId}'` for image attachments.

## Verification Plan

### Manual Verification
1.  Open the Home Screen.
2.  Tap your own profile photo (Header). Verify it expands and returns correctly.
3.  Navigate to a Caregiver's Profile. Verify the transition is smooth.
4.  Open a Chat. Tap a received image. Verify the Hero transition works without crashing.
5.  Check the debug console for any "Hero" related warnings or assertions.
