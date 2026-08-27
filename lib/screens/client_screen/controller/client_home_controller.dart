import 'package:carely_caregiver/repositories/client_repository.dart';
import 'package:carely_caregiver/routes/app_routes.dart';
import 'package:carely_caregiver/screens/care_giver_screens/all_schedule_screen/model/care_giver_schedule_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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

  // Upcoming bookings
  final RxList<CareGiverScheduleModel> upcomingBookings = <CareGiverScheduleModel>[].obs;
  final RxBool isBookingsLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _setPlaceholders();
    fetchUpcomingBookings();
  }

  void _setPlaceholders() {
    upcomingBookings.value = List.generate(2, (index) => CareGiverScheduleModel(
      id: 'placeholder_$index',
      clientId: '',
      clientName: 'Loading Name',
      clientAvatar: '',
      caregiverId: '',
      caregiverName: 'Caregiver Name',
      caregiverAvatar: '',
      recipientName: 'Recipient',
      relationship: 'Family',
      serviceName: 'General Care',
      date: '2026-08-27',
      shift: 'MORNING',
      startTime: '09:00',
      endTime: '11:00',
      status: 'PENDING',
      amount: 0.0,
      instructions: '',
    ));
  }

  Future<void> fetchUpcomingBookings() async {
    try {
      isBookingsLoading.value = true;
      update();

      // Fetch all bookings for the client. The API /booking/my already filters by user.
      // We don't filter by date here to show any upcoming booking, 
      // or we can pass the current date to get today's.
      final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final response = await ClientRepository.instance.getClientBookings(date: today);

      if (response.isSuccess) {
        final List dataList = response.data['data']?['data'] ?? [];
        upcomingBookings.value = dataList.map((e) => CareGiverScheduleModel.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint("Error fetching upcoming bookings: $e");
    } finally {
      isBookingsLoading.value = false;
      update();
    }
  }

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

  void onViewDetails(String bookingId) {
    Get.toNamed(AppRoutes.instance.clientBookingDetails, arguments: bookingId);
  }

  void onSeeAllBookings() {
    Get.toNamed(AppRoutes.instance.allScheduleScreen);
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
