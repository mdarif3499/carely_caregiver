import 'package:carely_caregiver/constant/app_api_end_point.dart';
import 'package:carely_caregiver/repositories/caregiver_repository.dart';
import 'package:carely_caregiver/repositories/chat_repository.dart';
import 'package:carely_caregiver/routes/app_routes.dart';
import 'package:carely_caregiver/screens/care_giver_screens/earning_screen/model/caregiver_earnings_model.dart';
import 'package:carely_caregiver/screens/chat_list_screen/controller/chat_list_controller.dart';
import 'package:carely_caregiver/services/share_pref_helper/share_pref_helper.dart';
import 'package:carely_caregiver/widgets/show_custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


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
  final String clientId;
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
    required this.clientId,
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
  final RxDouble totalWeeklyEarnings = 0.0.obs;
  final RxList<WeeklyBarData> weeklyBars = <WeeklyBarData>[].obs;
  final RxBool isEarningsLoading = false.obs;
  final RxBool isLoading = false.obs;

  // Today's schedule (Upcoming Booking)
  final RxList<TodayScheduleItem> todaySchedule = <TodayScheduleItem>[].obs;

  // Recent Activities
  final RxList<ActivityModel> recentActivities = <ActivityModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchEarningsSummary();
    _loadSchedule();
    _loadRecentActivities();
  }

  Future<void> fetchEarningsSummary() async {
    try {
      isEarningsLoading.value = true;
      update();

      final response = await CaregiverRepository.instance.getEarningsSummary();

      if (response.isSuccess) {
        final model = CaregiverEarningsModel.fromJson(response.data['data'] ?? {});
        
        // Use paidTotal as requested
        totalWeeklyEarnings.value = model.paidTotal;

        // Map breakdown to bars
        final List<WeeklyBarData> bars = [];
        final String currentDay = DateFormat('EEE').format(DateTime.now());

        double maxAmount = 0;
        for (var e in model.weeklyBreakdown) {
          if (e.amount > maxAmount) maxAmount = e.amount;
        }

        for (var e in model.weeklyBreakdown) {
          bars.add(WeeklyBarData(
            day: e.day,
            // Normalize height (min 0.1 for visibility if 0)
            value: maxAmount > 0 ? (e.amount / maxAmount).clamp(0.1, 1.0) : 0.1,
            isToday: e.day.toLowerCase() == currentDay.toLowerCase(),
          ));
        }
        weeklyBars.assignAll(bars);
      }
    } catch (e) {
      debugPrint("Error fetching earnings summary: $e");
    } finally {
      isEarningsLoading.value = false;
      update();
    }
  }

  void _loadSchedule() {
    todaySchedule.assignAll([
      const TodayScheduleItem(
        id: '1',
        clientId: '6a80072600c0207c32bf6acd', // Real client ID from your JSON
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
    Get.toNamed(AppRoutes.instance.bookingDetailsScreen, arguments: item.id);
  }

  Future<void> onChat(TodayScheduleItem item) async {
    try {
      isLoading.value = true;
      update();

      // For caregivers, the receiverId is the client's ID
      final response = await ChatRepository.instance.getOrCreateConversation(item.clientId);

      if (response.isSuccess) {
        final data = response.data['data'] ?? {};
        final currentUserId = await SharePrefsHelper.getString(SharedPreferenceValue.userId);
        final conversation = ChatConversation.fromJson(data, currentUserId);

        Get.toNamed(AppRoutes.instance.messageScreen, arguments: conversation);
      } else {
        showCustomSnackbar(message: response.message, isError: true);
      }
    } catch (e) {
      debugPrint("Error creating conversation: $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }
}
