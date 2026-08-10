import 'package:get/get.dart';

// ─────────────────────────────────────────────────────
//  Enums
// ─────────────────────────────────────────────────────
enum NotificationType { emergency, booking, message, payment, update }

enum NotificationFilter { all, unread, bookings, payments }

// ─────────────────────────────────────────────────────
//  Model
// ─────────────────────────────────────────────────────
class AppNotification {
  final String id;
  final String title;
  final String body;
  final String timeAgo;
  final NotificationType type;
  final bool isRead;
  final String group;

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.timeAgo,
    required this.type,
    required this.group,
    this.isRead = false,
  });
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

  final List<AppNotification> _all = const [
    AppNotification(
      id: '1',
      title: 'Emergency Alert',
      body: 'Unusual activity detected during session.',
      timeAgo: '2m ago',
      type: NotificationType.emergency,
      group: 'Today',
    ),
    AppNotification(
      id: '2',
      title: 'Booking Accepted',
      body: 'Sarah Jenkins has accepted your request.',
      timeAgo: '15m ago',
      type: NotificationType.booking,
      group: 'Today',
    ),
    AppNotification(
      id: '3',
      title: 'New Message',
      body: 'Caregiver Sarah: "I\'ve arrived at the location."',
      timeAgo: '1h ago',
      type: NotificationType.message,
      group: 'Today',
      isRead: true,
    ),
    AppNotification(
      id: '4',
      title: 'Payment Successful',
      body: 'Invoice #INV-88291 has been paid.',
      timeAgo: '3h ago',
      type: NotificationType.payment,
      group: 'Today',
      isRead: true,
    ),
    AppNotification(
      id: '5',
      title: 'App Update',
      body: 'A new version of CareConnect is available.',
      timeAgo: '1d ago',
      type: NotificationType.update,
      group: 'Yesterday',
      isRead: true,
    ),
    AppNotification(
      id: '6',
      title: 'New Message',
      body: 'Caregiver Sarah: "I\'ve arrived at the location."',
      timeAgo: '1d ago',
      type: NotificationType.message,
      group: 'Yesterday',
    ),
  ];

  List<AppNotification> get _filtered {
    switch (activeFilter.value) {
      case NotificationFilter.unread:
        return _all.where((n) => !n.isRead).toList();
      case NotificationFilter.bookings:
        return _all.where((n) => n.type == NotificationType.booking).toList();
      case NotificationFilter.payments:
        return _all.where((n) => n.type == NotificationType.payment).toList();
      case NotificationFilter.all:
        return _all;
    }
  }

  /// Flat list interleaving group labels + notification items for SmartListLoader
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

  void setFilter(NotificationFilter f) => activeFilter.value = f;
}
