import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:carely_caregiver/gen/assets.gen.dart';
import 'package:carely_caregiver/screens/profile_screens/profile_screen/profile_screen.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';

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
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: colors.border, width: 4),
            ),
            child: ClipOval(
              child: CommonImage(
                src: avatarUrl.isEmpty ? Assets.icons.profile : avatarUrl,
                fill: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),
          CommonText(
            text: displayName,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            textColor: colors.textPrimary,
          ),
          const SizedBox(height: 4),
          CommonText(
            text: displayMemberSince,
            fontSize: 14,
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
          fontSize: 16,
          fontWeight: FontWeight.w600,
          textColor: colors.secondaryText,
        ),
        const SizedBox(height: 12),
        Container(
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
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isLast = index == items.length - 1;
              return Column(
                children: [
                  _ProfileMenuTile(item: item),
                  if (!isLast) Divider(height: 1, indent: 64, color: colors.boxBg),
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
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colors.secondaryColor.withAlpha(15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(item.icon, size: 22, color: colors.secondaryColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CommonText(
                text: item.title,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                textColor: colors.textPrimary,
                textAlign: TextAlign.start,
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: colors.secondaryText, size: 24),
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
      margin: const EdgeInsets.only(top: 12),
      child: CommonButton(
        titleText: 'Log Out',
        buttonColor: colors.error.withAlpha(15),
        titleColor: colors.error,
        onTap: onTap,
        prefix: Icon(Icons.logout_rounded, size: 20, color: colors.error),
      ),
    );
  }
}
