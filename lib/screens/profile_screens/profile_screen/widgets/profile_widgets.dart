import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:carely_caregiver/gen/assets.gen.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_routes.dart';

// ── Menu Item Model ──────────────────────────────────────
class ProfileMenuItem {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const ProfileMenuItem({required this.icon, required this.title, this.onTap});
}

class ProfileAvatarHeader extends StatelessWidget {
  final String name;
  final String memberSince;
  final String avatarUrl;

  const ProfileAvatarHeader({
    super.key,
    required this.name,
    required this.memberSince,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    final displayName = name.isEmpty ? 'User' : name;
    final displayMemberSince = memberSince.isEmpty ? 'Loading account details...' : memberSince;

    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              if (avatarUrl.isNotEmpty) {
                Get.toNamed(AppRoutes.instance.fullScreenImage, arguments: {
                  "url": avatarUrl,
                  "tag": 'profile_main_$avatarUrl',
                });
              }
            },
            child: Hero(
              tag: avatarUrl.isEmpty ? 'profile_main_default' : 'profile_main_$avatarUrl',
              child: Container(
                width: 120.w,
                height: 120.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.border, width: 4.w),
                ),
                child: ClipOval(
                  child: CommonImage(
                    src: avatarUrl.isEmpty ? Assets.icons.profile : avatarUrl,
                    fill: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          CommonText(
            text: displayName,
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
            textColor: colors.textPrimary,
          ),
          SizedBox(height: 4.h),
          CommonText(
            text: displayMemberSince,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            textColor: colors.secondaryText,
          ),
        ],
      ),
    );
  }
}

class ProfileSection extends StatelessWidget {
  final String title;
  final List<ProfileMenuItem> items;

  const ProfileSection({super.key, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(
          text: title,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          textColor: colors.secondaryText,
        ),
        SizedBox(height: 12.h),
        Container(
          decoration: BoxDecoration(
            color: colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(5),
                blurRadius: 10.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: Column(
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isLast = index == items.length - 1;
              return Column(
                children: [
                  _ProfileMenuTile(item: item),
                  if (!isLast) Divider(height: 1.h, indent: 64.w, color: colors.boxBg),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _ProfileMenuTile extends StatelessWidget {
  final ProfileMenuItem item;

  const _ProfileMenuTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;

    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: colors.secondaryColor.withAlpha(15),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(item.icon, size: 22.sp, color: colors.secondaryColor),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: CommonText(
                text: item.title,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                textColor: colors.textPrimary,
                textAlign: TextAlign.start,
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: colors.secondaryText, size: 24.sp),
          ],
        ),
      ),
    );
  }
}

class LogoutButton extends StatelessWidget {
  final VoidCallback onTap;
  const LogoutButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 12.h),
      child: CommonButton(
        titleText: 'Log Out',
        buttonColor: colors.error.withAlpha(15),
        titleColor: colors.error,
        onTap: onTap,
        prefix: Icon(Icons.logout_rounded, size: 20.sp, color: colors.error),
      ),
    );
  }
}
