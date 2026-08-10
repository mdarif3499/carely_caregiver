import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:carely_caregiver/screens/notification_screen/controller/notification_screen_controller.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';

class NotificationFilterRow extends StatelessWidget {
  final NotificationFilter active;
  final Function(NotificationFilter) onTap;

  const NotificationFilterRow({super.key, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: NotificationFilter.values.map((f) {
          final isSelected = active == f;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => onTap(f),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? colors.primary : colors.boxBg.withAlpha(50),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: CommonText(
                  text: _filterLabel(f),
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  textColor: isSelected ? colors.white : colors.secondaryText,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _filterLabel(NotificationFilter f) {
    switch (f) {
      case NotificationFilter.all: return 'All';
      case NotificationFilter.unread: return 'Unread';
      case NotificationFilter.bookings: return 'Bookings';
      case NotificationFilter.payments: return 'Payments';
    }
  }
}

class NotificationGroupLabel extends StatelessWidget {
  final String label;
  const NotificationGroupLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: CommonText(
        text: label,
        fontSize: 18,
        fontWeight: FontWeight.w700,
        textColor: AppColors.instance.secondaryText.withAlpha(180),
        textAlign: TextAlign.start,
      ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  final AppNotification notification;
  const NotificationItem({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Type Icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _bgColor(notification.type, colors),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _icon(notification.type),
              size: 22,
              color: _iconColor(notification.type, colors),
            ),
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CommonText(
                      text: notification.title,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      textColor: colors.textPrimary,
                    ),
                    Row(
                      children: [
                        CommonText(
                          text: notification.timeAgo,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          textColor: colors.error.withAlpha(180),
                        ),
                        if (!notification.isRead) ...[
                          const SizedBox(width: 6),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: notification.type == NotificationType.emergency ? colors.error : colors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ]
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                CommonText(
                  text: notification.body,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  textColor: colors.secondaryText,
                  textAlign: TextAlign.start,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _bgColor(NotificationType type, AppColors colors) {
    switch (type) {
      case NotificationType.emergency: return colors.error.withAlpha(15);
      case NotificationType.booking: return colors.primary.withAlpha(15);
      case NotificationType.message: return colors.orange.withAlpha(15);
      case NotificationType.payment: return colors.success.withAlpha(15);
      case NotificationType.update: return colors.textGrey.withAlpha(15);
    }
  }

  Color _iconColor(NotificationType type, AppColors colors) {
    switch (type) {
      case NotificationType.emergency: return colors.error;
      case NotificationType.booking: return colors.primary;
      case NotificationType.message: return colors.orange;
      case NotificationType.payment: return colors.success;
      case NotificationType.update: return colors.textGrey;
    }
  }

  IconData _icon(NotificationType type) {
    switch (type) {
      case NotificationType.emergency: return Icons.remove_circle_outline_rounded;
      case NotificationType.booking: return Icons.check_circle_outline_rounded;
      case NotificationType.message: return Icons.chat_bubble_outline_rounded;
      case NotificationType.payment: return Icons.check_circle_outline_rounded;
      case NotificationType.update: return Icons.check_circle_outline_rounded;
    }
  }
}
