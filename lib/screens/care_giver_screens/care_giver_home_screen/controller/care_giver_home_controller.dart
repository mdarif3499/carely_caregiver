import 'package:carely_caregiver/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ── Models ─────────────────────────────────────────────
class WeeklyBarData {
  final String day;
  final double value;
  final bool isToday;
  const WeeklyBarData({
    required this.day,
    required this.value,
    this.isToday = false,
  });
}

class TodayScheduleItem {
  final String id;
  final String startTime;
  final String endTime;
  final String clientName;
  final String clientRole;
  final String address;
  final String status;
  final String avatarUrl;
  final List<String> tags;
  const TodayScheduleItem({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.clientName,
    required this.clientRole,
    required this.address,
    required this.status,
    required this.avatarUrl,
    required this.tags,
  });

  String get timeRange => 'Today, $startTime - $endTime';
}

enum ActivityType { booking, message }

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

// ── Controller ─────────────────────────────────────────
class CareGiverHomeController extends GetxController {
  // Search
  final TextEditingController searchController = TextEditingController();

  void onNotificationTap() {
    Get.toNamed(AppRoutes.instance.notificationScreen);
  }
  void onSeeAllSchedule() {
    Get.toNamed(AppRoutes.instance.allScheduleScreen);
  }
  void onFilterTap() {}

  // Weekly earnings
  final RxDouble totalWeeklyEarnings = 1248.50.obs;
  final RxList<WeeklyBarData> weeklyBars = <WeeklyBarData>[].obs;

  // Today's schedule (Upcoming Booking)
  final RxList<TodayScheduleItem> todaySchedule = <TodayScheduleItem>[].obs;

  // Recent Activities
  final RxList<ActivityModel> recentActivities = <ActivityModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadWeeklyData();
    _loadSchedule();
    _loadRecentActivities();
  }

  void _loadWeeklyData() {
    weeklyBars.assignAll([
      const WeeklyBarData(day: 'Mon', value: 0.45),
      const WeeklyBarData(day: 'Tue', value: 0.55),
      const WeeklyBarData(day: 'Wed', value: 0.35),
      const WeeklyBarData(day: 'Thu', value: 0.60),
      const WeeklyBarData(day: 'Fri', value: 0.50),
      const WeeklyBarData(day: 'Sat', value: 0.65),
      const WeeklyBarData(day: 'Sun', value: 0.90, isToday: true),
    ]);
  }

  void _loadSchedule() {
    todaySchedule.assignAll([
      const TodayScheduleItem(
        id: '1',
        startTime: '2:00 PM',
        endTime: '4:00 PM',
        clientName: 'Sarah Jenkins',
        clientRole: 'RN',
        address: '456 Oak Avenue, Apt 4B',
        status: 'Confirmed',
        avatarUrl: 'https://images.unsplash.com/photo-1594824476967-48c8b964273f?q=80&w=1000&auto=format&fit=crop',
        tags: ['Rehab', 'Vital Signs'],
      ),
    ]);
  }

  void _loadRecentActivities() {
    recentActivities.assignAll([
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
    ]);
  }

  void onViewDetails(TodayScheduleItem item) {
    // Navigate to details
  }

  void onChat(TodayScheduleItem item) {
    // Navigate to chat
  }
}
