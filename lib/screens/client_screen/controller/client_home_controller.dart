import 'package:carely_caregiver/routes/app_routes.dart';
import 'package:get/get.dart';

// ── Data Models ─────────────────────────
class BookingModel {
  final String name;
  final String role;
  final String status;
  final String dateTime;
  final String avatarUrl;

  const BookingModel({
    required this.name,
    required this.role,
    required this.status,
    required this.dateTime,
    required this.avatarUrl,
  });
}

class ActivityModel {
  final String title;
  final String description;
  final String timeAgo;
  final ActivityType type;

  const ActivityModel({
    required this.title,
    required this.description,
    required this.timeAgo,
    required this.type,
  });
}

enum ActivityType { booking, message }

// ── Controller ──────────────────────────
class ClientHomeController extends GetxController {
  // Search
  final RxString searchQuery = ''.obs;
  void onSearchChanged(String val) => searchQuery.value = val;

  // User info
  final String userName = 'Jane Cooper';
  final String userAvatarUrl = '';

  // Upcoming booking
  final Rx<BookingModel> upcomingBooking = Rx<BookingModel>(
    const BookingModel(
      name: 'Sarah Jenkins',
      role: 'RN',
      status: 'Confirmed',
      dateTime: 'Today, 2:00 PM – 4:00 PM',
      avatarUrl: '',
    ),
  );

  // Recent activities
  final RxList<ActivityModel> recentActivities = <ActivityModel>[
    const ActivityModel(
      title: 'Booking confirmed for Friday',
      description: 'Your session with Marcus L. has been scheduled.',
      timeAgo: '2 hours ago',
      type: ActivityType.booking,
    ),
    const ActivityModel(
      title: 'New message from Sarah J.',
      description: '"I\'ll be arriving 5 minutes early today ... "',
      timeAgo: '4 hours ago',
      type: ActivityType.message,
    ),
    const ActivityModel(
      title: 'Booking confirmed for Friday',
      description: 'Your session with Marcus L. has been scheduled.',
      timeAgo: '12 hours ago',
      type: ActivityType.booking,
    ),
  ].obs;

  void onViewDetails() {
    Get.toNamed(AppRoutes.instance.careGiverDetailsScreen);
  }

  void onSeeAllBookings() {
    // TODO: navigate to all bookings
  }

  void onLearnMore() {
    // TODO: navigate to learn more
  }

  void onFilterTap() {
    // TODO: open filter bottom sheet
  }

  void onNotificationTap() {
    Get.toNamed(AppRoutes.instance.notificationScreen);
  }
}
