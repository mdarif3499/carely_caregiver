import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:carely_caregiver/routes/app_routes.dart';
import 'package:carely_caregiver/screens/care_giver_screens/care_giver_home_screen/controller/care_giver_home_controller.dart';
import 'package:carely_caregiver/utils/app_utils.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CareGiverHeader extends StatelessWidget {
  final String userName;
  final String avatarUrl;
  final VoidCallback? onNotificationTap;

  const CareGiverHeader({
    super.key,
    required this.userName,
    required this.avatarUrl,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: colors.boxBg,
          backgroundImage: avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
          child: avatarUrl.isEmpty
              ? Icon(Icons.person, color: colors.primary, size: 26)
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonText(
                text: AppUtils.getGreeting(),
                fontSize: 14,
                fontWeight: FontWeight.w400,
                textColor: colors.secondaryText,
                textAlign: TextAlign.start,
              ),
              CommonText(
                text: userName,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                textColor: colors.textPrimary,
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
        _IconButton(icon: Icons.notifications_none_rounded, onTap: onNotificationTap, hasBadge: true),
      ],
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool hasBadge;

  const _IconButton({required this.icon, this.onTap, this.hasBadge = false});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    return GestureDetector(
      onTap: onTap ?? () {
        Get.toNamed(AppRoutes.instance.notificationScreen);
      },
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: colors.boxBg),
            ),
            child: Icon(icon, size: 22, color: colors.textPrimary),
          ),
          if (hasBadge)
            Positioned(
              right: 2,
              top: 2,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: colors.error, shape: BoxShape.circle, border: Border.all(color: colors.white, width: 1.5)),
              ),
            ),
        ],
      ),
    );
  }
}

class CareGiverSearchBar extends StatelessWidget {
  final TextEditingController controller;
  const CareGiverSearchBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    return CommonTextField(
      controller: controller,
      hintText: 'Search by name, role, or city',
      backgroundColor: colors.boxBg,
      borderColor: Colors.transparent,
      borderRadius: 14,
      prefixIcon: Icon(Icons.search, color: colors.secondaryText, size: 22),
      validationType: ValidationType.notRequired,
    );
  }
}

class CareGiverBannerCard extends StatelessWidget {
  const CareGiverBannerCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    return Container(
      width: double.infinity,
      height: 190,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [colors.secondaryColor.withAlpha(200), colors.primary.withAlpha(180)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(right: -20, top: -20, child: CircleAvatar(radius: 80, backgroundColor: Colors.white.withAlpha(20))),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CommonText(
                  text: 'Professional Care at\nYour Doorstep',
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  textColor: Colors.white,
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 8),
                CommonText(
                  text: 'Compassionate home healthcare for your loved ones.',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  textColor: Colors.white.withAlpha(220),
                  textAlign: TextAlign.start,
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: CommonText(text: 'Learn More', fontSize: 14, fontWeight: FontWeight.w700, textColor: colors.textPrimary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CareGiverScheduleCard extends StatelessWidget {
  final TodayScheduleItem item;
  final VoidCallback onTap;

  const CareGiverScheduleCard({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            // Start Time Box
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: colors.boxBg.withAlpha(50),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  CommonText(text: 'START', fontSize: 10, fontWeight: FontWeight.w600, textColor: colors.secondaryText),
                  const SizedBox(height: 4),
                  CommonText(text: item.startTime, fontSize: 14, fontWeight: FontWeight.w700, textColor: colors.textPrimary),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(text: item.clientName, fontSize: 16, fontWeight: FontWeight.w700, textColor: colors.textPrimary),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 14, color: colors.secondaryText),
                      const SizedBox(width: 4),
                      Expanded(
                        child: CommonText(
                          text: item.address,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          textColor: colors.secondaryText,
                          textAlign: TextAlign.start,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Tags
                  Wrap(
                    spacing: 8,
                    children: item.tags.map((tag) => _Tag(label: tag)).toList(),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: colors.secondaryText, size: 24),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  const _Tag({required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: label.toLowerCase().contains('rehab') ? colors.primary.withAlpha(15) : colors.highlight.withAlpha(15),
        borderRadius: BorderRadius.circular(50),
      ),
      child: CommonText(
        text: label,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        textColor: label.toLowerCase().contains('rehab') ? colors.primary : colors.highlight,
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: Colors.green.withAlpha(30), borderRadius: BorderRadius.circular(50)),
      child: CommonText(text: status, fontSize: 11, fontWeight: FontWeight.w600, textColor: Colors.green),
    );
  }
}

class ActivityItemWidget extends StatelessWidget {
  final ActivityModel activity;
  const ActivityItemWidget({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    final isMessage = activity.type == ActivityType.message;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: isMessage ? colors.orange.withAlpha(20) : colors.secondaryColor.withAlpha(20), borderRadius: BorderRadius.circular(12)),
            child: Icon(isMessage ? Icons.chat_bubble_outline_rounded : Icons.check_circle_outline_rounded, size: 20, color: isMessage ? colors.orange : colors.secondaryColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(text: activity.title, fontSize: 16, fontWeight: FontWeight.w600, textColor: colors.textPrimary, textAlign: TextAlign.start),
                const SizedBox(height: 2),
                CommonText(text: activity.description, fontSize: 14, fontWeight: FontWeight.w400, textColor: colors.secondaryText, textAlign: TextAlign.start),
                const SizedBox(height: 4),
                CommonText(text: activity.timeAgo, fontSize: 12, fontWeight: FontWeight.w500, textColor: colors.textGrey, textAlign: TextAlign.start),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
