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
  final VoidCallback onTap;

  const NotificationItem({super.key, required this.notification, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
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
                      Expanded(
                        child: CommonText(
                          text: notification.title,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          textColor: colors.textPrimary,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Row(
                        children: [
                          CommonText(
                            text: notification.timeAgo,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            textColor: colors.secondaryText.withAlpha(150),
                          ),
                          if (!notification.isRead) ...[
                            const SizedBox(width: 8),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: colors.primary,
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
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _bgColor(String type, AppColors colors) {
    if (type.contains('emergency')) return colors.error.withAlpha(15);
    if (type.contains('booking')) return colors.primary.withAlpha(15);
    if (type.contains('message')) return colors.orange.withAlpha(15);
    if (type.contains('payment')) return colors.success.withAlpha(15);
    return colors.textGrey.withAlpha(15);
  }

  Color _iconColor(String type, AppColors colors) {
    if (type.contains('emergency')) return colors.error;
    if (type.contains('booking')) return colors.primary;
    if (type.contains('message')) return colors.orange;
    if (type.contains('payment')) return colors.success;
    return colors.textGrey;
  }

  IconData _icon(String type) {
    if (type.contains('emergency')) return Icons.report_problem_outlined;
    if (type.contains('booking_completed')) return Icons.task_alt_rounded;
    if (type.contains('booking_confirmed')) return Icons.check_circle_outline_rounded;
    if (type.contains('booking_auto_released')) return Icons.timer_off_outlined;
    if (type.contains('booking')) return Icons.calendar_today_outlined;
    if (type.contains('message')) return Icons.chat_bubble_outline_rounded;
    if (type.contains('payment')) return Icons.payments_outlined;
    return Icons.notifications_none_rounded;
  }
}
