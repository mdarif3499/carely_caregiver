import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:carely_caregiver/routes/app_routes.dart';
import 'package:carely_caregiver/utils/app_utils.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../care_giver_screens/all_schedule_screen/model/care_giver_schedule_model.dart';

class ClientHomeHeader extends StatelessWidget {
  final String userName;
  final String avatarUrl;
  final VoidCallback? onNotificationTap;

  const ClientHomeHeader({
    super.key,
    required this.userName,
    required this.avatarUrl,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    return Padding(
      padding: const EdgeInsets.only(right: 22.0),
      child: Row(
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
      ),
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

class ClientSearchBar extends StatelessWidget {
  final Function(String)? onChanged;
  const ClientSearchBar({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    return CommonTextField(
      hintText: 'Search by name, role, or city',
      backgroundColor: colors.boxBg.withAlpha(50),
      borderColor: Colors.transparent,
      borderRadius: 14,
      prefixIcon: Icon(Icons.search, color: colors.secondaryText, size: 22),
      validationType: ValidationType.notRequired,
      onChanged: onChanged,
    );
  }
}

class ProfessionalCareBanner extends StatelessWidget {
  final VoidCallback onTap;
  const ProfessionalCareBanner({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    return Container(
      width: double.infinity,
      height: 230,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: AssetImage('assets/images/home_back.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              const Color(0xFF4DB6FF).withAlpha(200),
              const Color(0xFF0D8C8A).withAlpha(180),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CommonText(
                text: 'Professional Care at\nYour Doorstep',
                fontSize: 32,
                fontWeight: FontWeight.w700,
                textColor: Colors.white,
                textAlign: TextAlign.start,
                maxLines: 2,
              ),
              const SizedBox(height: 8),
            const  CommonText(
                text: 'Compassionate home healthcare for your loved ones.',
                fontSize: 17,
                fontWeight: FontWeight.w500,
                textColor: Colors.white,
                textAlign: TextAlign.start,
              ),
              const Spacer(),
              GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CommonText(
                    text: 'Learn More',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    textColor: colors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ClientUpcomingBookingCard extends StatelessWidget {
  final CareGiverScheduleModel booking;
  final VoidCallback onViewDetails;
  final VoidCallback onChat;

  const ClientUpcomingBookingCard({
    super.key,
    required this.booking,
    required this.onViewDetails,
    required this.onChat,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    return Container(
      width: 320, // Fixed width for horizontal scrolling
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.boxBg),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: colors.boxBg,
                backgroundImage: booking.caregiverAvatar.isNotEmpty ? NetworkImage(booking.caregiverAvatar) : null,
                child: booking.caregiverAvatar.isEmpty ? Icon(Icons.person, color: colors.primary, size: 26) : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: CommonText(
                            text: booking.caregiverName,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            textColor: colors.textPrimary,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        const SizedBox(width: 4),
                        _StatusBadge(label: booking.status),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.calendar_today_outlined, size: 14, color: colors.secondaryText),
                        const SizedBox(width: 6),
                        CommonText(
                          text: booking.formattedTimeRange,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          textColor: colors.secondaryText,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CommonButton(
                  titleText: 'View Details',
                  buttonColor: colors.secondaryColor,
                  titleColor: colors.white,
                  onTap: onViewDetails,
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: onChat,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: colors.secondaryColor.withAlpha(20), shape: BoxShape.circle),
                  child: Icon(Icons.chat_bubble_outline_rounded, size: 22, color: colors.secondaryColor),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: Colors.green.withAlpha(30), borderRadius: BorderRadius.circular(50)),
      child: CommonText(text: label, fontSize: 11, fontWeight: FontWeight.w600, textColor: Colors.green),
    );
  }
}

class ServiceCategoryItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const ServiceCategoryItem({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(5),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.primary.withAlpha(15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: colors.primary, size: 28),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: CommonText(
                text: title,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                textColor: colors.textPrimary,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
