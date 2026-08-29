# Professional Notification System Implementation

Implement a professional notification system using real-time API data, supporting dynamic icons, grouping by date, and pagination.

## Proposed Changes

### [Core]

#### [MODIFY] [app_api_end_point.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/constant/app_api_end_point.dart)
- Add `static const String notifications = "/notification/my";`

### [Repository]

#### [NEW] [notification_repository.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/repositories/notification_repository.dart)
- Implement `getMyNotifications({int page = 1})` to fetch data from the API.

### [Notification Screen]

#### [MODIFY] [notification_screen_controller.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/notification_screen/controller/notification_screen_controller.dart)
- **Professional Model**: Refactor `AppNotification` to match the API response.
- **State Management**:
    - Add `isLoading`, `isMoreLoading`.
    - Use `RxList<AppNotification>` for reactive updates.
    - Implement pagination logic (`currentPage`, `hasMore`).
- **Grouping Logic**: Dynamically group notifications into "Today", "Yesterday", and "Older" based on `createdAt`.
- **Filtering**: Support filtering by "All", "Unread", "Bookings", and "Payments" using the `type` field.

#### [MODIFY] [notification_widgets.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/notification_screen/widgets/notification_widgets.dart)
- **Dynamic Icons**: Map `type` (e.g., `booking_completed`, `booking_confirmed`) to professional Material icons.
- **Modern Item UI**:
    - Show unread indicator.
    - Professional color coding for different notification types.
    - Improved typography and spacing.

#### [MODIFY] [notification_screen.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/notification_screen/notification_screen.dart)
- Integrate `Skeletonizer` for loading states.
- Support "Pull to Refresh".
- Implement infinite scroll loading using `SmartListLoader`.

## Verification Plan

### Manual Verification
1.  Open the Notification screen.
2.  Verify loading shimmer appears.
3.  Verify notifications are fetched from the server.
4.  Check that icons and colors match the notification type.
5.  Verify grouping (Today/Yesterday/Older) is correct.
6.  Test "Pull to Refresh".
7.  Verify pagination works by scrolling to the bottom.
