import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:carely_caregiver/routes/app_routes.dart';
import 'package:carely_caregiver/screens/client_screen/controller/client_home_controller.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../gen/assets.gen.dart';

// ═══════════════════════════════════════════════════════
//  1. Home Header — Avatar + Name + Icons
// ═══════════════════════════════════════════════════════

class HomeHeaderWidget extends StatelessWidget {
  final String userName;
  final String avatarUrl;
  final bool showFilter;
  final VoidCallback? onFilterTap;
  final VoidCallback? onNotificationTap;

  const HomeHeaderWidget({
    super.key,
    required this.userName,
    this.avatarUrl = '',
    this.showFilter = true,
    this.onFilterTap,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Avatar
        CircleAvatar(
          radius: 22,
          backgroundColor: AppColors.instance.boxBg,
          backgroundImage: avatarUrl.isNotEmpty
              ? NetworkImage(avatarUrl)
              : null,
          child: avatarUrl.isEmpty
              ? Icon(Icons.person, color: AppColors.instance.primary, size: 24)
              : null,
        ),
        const SizedBox(width: 10),

        // Name + welcome text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonText(
                text: 'Welcome back!',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                textColor: AppColors.instance.secondaryText,
                textAlign: TextAlign.start,
                isDescription: true,
                preventScaling: true,
              ),
              CommonText(
                text: userName,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                textColor: AppColors.instance.textPrimary,
                textAlign: TextAlign.start,
                isDescription: true,
                preventScaling: true,
              ),
            ],
          ),
        ),

        // Filter icon
       showFilter? AppIconButton(icon: Icons.tune_rounded, onTap: onFilterTap):SizedBox(),
        const SizedBox(width: 8),

        // Notification icon
        const AppIconButton(
          icon: Icons.notifications_outlined,
          hasBadge: true,
        ),
      ],
    );
  }
}

class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool hasBadge;

  const AppIconButton({super.key, required this.icon, this.onTap, this.hasBadge = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? (){
        Get.toNamed(AppRoutes.instance.notificationScreen);
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.instance.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: AppColors.instance.border),
            ),
            child: Icon(icon, size: 20, color: AppColors.instance.textPrimary),
          ),
          if (hasBadge)
            Positioned(
              top: 6,
              right: 7,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.instance.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════
//  2. Search Bar
// ═══════════════════════════════════════════════════════

class HomeSearchBar extends StatelessWidget {
  final Function(String)? onChanged;
  final TextEditingController? controller;

  const HomeSearchBar({super.key, this.onChanged, this.controller});

  @override
  Widget build(BuildContext context) {
    return CommonTextField(
      validationType: ValidationType.notRequired,
      controller: controller,
      hintText: 'Search by name, role, or city',
      backgroundColor: AppColors.instance.textFiledBg,
      borderColor: AppColors.instance.transparent,
      borderRadius: 12,
      paddingVertical: 13,
      prefixIcon: Icon(
        Icons.search,
        color: AppColors.instance.secondaryText,
        size: 20,
      ),
      onChanged: onChanged,
    );
  }
}

// ═══════════════════════════════════════════════════════
//  3. Hero Banner Card
// ═══════════════════════════════════════════════════════

class HomeBannerCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonLabel;
  final VoidCallback? onButtonTap;

  const HomeBannerCard({
    super.key,
    this.title = 'Professional Care at\nYour Doorstep',
    this.subtitle = 'Compassionate home healthcare for your loved ones.',
    this.buttonLabel = 'Learn More',
    this.onButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xFF2AA8A0), Color(0xFF1B6CA8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Background decorative circle
          Positioned(
            right: -20,
            top: -30,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withAlpha(20),
              ),
            ),
          ),
          Positioned(
            right: 40,
            bottom: -40,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withAlpha(15),
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  text: title,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  textColor: Colors.white,
                  textAlign: TextAlign.start,
                  isDescription: true,
                  preventScaling: true,
                ),
                const SizedBox(height: 6),
                CommonText(
                  text: subtitle,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  textColor: Colors.white.withAlpha(220),
                  textAlign: TextAlign.start,
                  isDescription: true,
                  preventScaling: true,
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onButtonTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: CommonText(
                      text: buttonLabel,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      textColor: AppColors.instance.textPrimary,
                      isDescription: true,
                      preventScaling: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════
//  4. Section Header Row (title + See All)
// ═══════════════════════════════════════════════════════

class HomeSectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  const HomeSectionHeader({
    super.key,
    required this.title,
    this.actionLabel = 'See All',
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CommonText(
          text: title,
          fontSize: 20,
          fontWeight: FontWeight.w500,
          textColor: AppColors.instance.textPrimary,
          textAlign: TextAlign.start,
          isDescription: true,
          preventScaling: true,
        ),
        if (actionLabel != null)
          GestureDetector(
            onTap: onActionTap,
            child: CommonText(
              text: actionLabel!,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              textColor: AppColors.instance.primary,
              isDescription: true,
              preventScaling: true,
            ),
          ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════
//  5. Upcoming Booking Card
// ═══════════════════════════════════════════════════════

class UpcomingBookingCard extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback? onViewDetails;
  final VoidCallback? onChat;

  const UpcomingBookingCard({
    super.key,
    required this.booking,
    this.onViewDetails,
    this.onChat,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.instance.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.instance.border),
      ),
      child: Column(
        children: [
          // Top row — avatar, name + badge, datetime
          Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.instance.boxBg,
                backgroundImage: booking.avatarUrl.isNotEmpty
                    ? NetworkImage(booking.avatarUrl)
                    : null,
                child: booking.avatarUrl.isEmpty
                    ? Icon(
                        Icons.person,
                        color: AppColors.instance.primary,
                        size: 26,
                      )
                    : null,
              ),
              const SizedBox(width: 12),

              // Name + status + datetime
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CommonText(
                          text: '${booking.name}, ${booking.role}',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          textColor: AppColors.instance.textPrimary,
                          textAlign: TextAlign.start,
                          isDescription: true,
                          preventScaling: true,
                        ),
                        const SizedBox(width: 8),
                        _StatusBadge(label: booking.status),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        CommonImage(src: Assets.icons.sBooking,height: 20,width: 20,),
                        const SizedBox(width: 4),
                        CommonText(
                          text: booking.dateTime,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          textColor: AppColors.instance.secondaryText,
                          textAlign: TextAlign.start,
                          isDescription: true,
                          preventScaling: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Bottom row — View Details + chat
          Row(
            children: [
              Expanded(
                child: CommonButton(
                  titleText: 'View Details',
                  buttonWidth: double.infinity,
                  elevation: 0,
                  onTap: onViewDetails,
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: onChat,
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.instance.boxBg,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CommonImage(src: Assets.icons.sMessage,height: 20,width: 20,),
                  )
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  const _StatusBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFE6FAF0),
        borderRadius: BorderRadius.circular(50),
      ),
      child: CommonText(
        text: label,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        textColor: const Color(0xFF11A960),
        isDescription: true,
        preventScaling: true,
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════
//  6. Activity Item
// ═══════════════════════════════════════════════════════

class ActivityItemWidget extends StatelessWidget {
  final ActivityModel activity;

  const ActivityItemWidget({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    final isMessage = activity.type == ActivityType.message;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: isMessage
                  ? const Color(0xFFFFF3E0)
                  : AppColors.instance.boxBg,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              isMessage
                  ? Icons.chat_bubble_outline_rounded
                  : Icons.check_circle_outline_rounded,
              color: isMessage
                  ? AppColors.instance.orange
                  : AppColors.instance.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  text: activity.title,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  textColor: AppColors.instance.textPrimary,
                  textAlign: TextAlign.start,
                  isDescription: true,
                  preventScaling: true,
                ),
                const SizedBox(height: 2),
                CommonText(
                  text: activity.description,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  textColor: AppColors.instance.secondaryText,
                  textAlign: TextAlign.start,
                  isDescription: true,
                  preventScaling: true,
                ),
                const SizedBox(height: 4),
                CommonText(
                  text: activity.timeAgo,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  textColor: AppColors.instance.textGrey,
                  textAlign: TextAlign.start,
                  isDescription: true,
                  preventScaling: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
