import 'package:carely_caregiver/repositories/notification_repository.dart';
import 'package:flutter/material.dart';
import 'package:core_kit/core_kit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// ─────────────────────────────────────────────────────
//  Enums
// ─────────────────────────────────────────────────────
enum NotificationFilter { all, unread }

// ─────────────────────────────────────────────────────
//  Model
// ─────────────────────────────────────────────────────
class AppNotification {
  final String id;
  final String title;
  final String body;
  final String type;
  final bool isRead;
  final DateTime createdAt;

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.createdAt,
    this.isRead = false,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      type: json['type'] ?? '',
      isRead: json['isRead'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  String get timeAgo {
    final now = DateTime.now();
    final diff = now.difference(createdAt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  String get group {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final date = DateTime(createdAt.year, createdAt.month, createdAt.day);

    if (date == today) return 'Today';
    if (date == yesterday) return 'Yesterday';
    return DateFormat('MMMM d, yyyy').format(createdAt);
  }
}

// Flat list item: either a section label or a notification row
class NotifListItem {
  final String? groupLabel;
  final AppNotification? notification;
  const NotifListItem.label(this.groupLabel) : notification = null;
  const NotifListItem.item(this.notification) : groupLabel = null;
  bool get isLabel => groupLabel != null;
}

// ─────────────────────────────────────────────────────
//  Controller
// ─────────────────────────────────────────────────────
class NotificationScreenController extends GetxController {
  final Rx<NotificationFilter> activeFilter = NotificationFilter.all.obs;
  final RxList<AppNotification> notifications = <AppNotification>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isMoreLoading = false.obs;
  final RxInt currentPage = 1.obs;
  final RxBool hasMore = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications({bool isRefresh = false}) async {
    if (isRefresh) {
      currentPage.value = 1;
      hasMore.value = true;
    }

    try {
      if (currentPage.value == 1) {
        isLoading.value = true;
      } else {
        isMoreLoading.value = true;
      }
      update();

      final response = await NotificationRepository.instance.getMyNotifications(page: currentPage.value);

      if (response.isSuccess) {
        final List dataList = response.data['data'] ?? [];
        final List<AppNotification> fetched = dataList.map((e) => AppNotification.fromJson(e)).toList();

        if (currentPage.value == 1) {
          notifications.assignAll(fetched);
        } else {
          notifications.addAll(fetched);
        }

        final meta = response.data['meta'] ?? {};
        hasMore.value = fetched.length >= 10 && currentPage.value < (meta['totalPages'] ?? 1);
      } else {
        if (currentPage.value == 1) notifications.clear();
      }
    } catch (e) {
      debugPrint("Error fetching notifications: $e");
    } finally {
      isLoading.value = false;
      isMoreLoading.value = false;
      update();
    }
  }

  Future<void> loadMore() async {
    if (!hasMore.value || isMoreLoading.value) return;
    currentPage.value++;
    await fetchNotifications();
  }

  List<AppNotification> get _filtered {
    final List<AppNotification> base = notifications;
    switch (activeFilter.value) {
      case NotificationFilter.unread:
        return base.where((n) => !n.isRead).toList();
      case NotificationFilter.all:
        return base;
    }
  }

  /// Flat list interleaving group labels + notification items
  List<NotifListItem> get flatItems {
    final grouped = <String, List<AppNotification>>{};
    for (final n in _filtered) {
      grouped.putIfAbsent(n.group, () => []).add(n);
    }
    final result = <NotifListItem>[];
    for (final entry in grouped.entries) {
      result.add(NotifListItem.label(entry.key));
      result.addAll(entry.value.map((n) => NotifListItem.item(n)));
    }
    return result;
  }

  void setFilter(NotificationFilter f) {
    activeFilter.value = f;
    update();
  }

  Future<void> onNotificationTap(AppNotification n) async {
    // Show full notification in a dialog
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          n.title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        content: SingleChildScrollView(
          child: Text(
            n.body,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Close',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );

    if (!n.isRead) {
      try {
        await NotificationRepository.instance.markAsRead(n.id);
        final index = notifications.indexWhere((element) => element.id == n.id);
        if (index != -1) {
          notifications[index] = AppNotification(
            id: n.id,
            title: n.title,
            body: n.body,
            type: n.type,
            createdAt: n.createdAt,
            isRead: true,
          );
          notifications.refresh();
        }
      } catch (e) {
        debugPrint("Error marking notification as read: $e");
      }
    }
  }
}
