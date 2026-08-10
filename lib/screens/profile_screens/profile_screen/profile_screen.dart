import 'package:carely_caregiver/app_all_enum/app_login_status.dart';
import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:carely_caregiver/routes/app_routes.dart';
import 'package:carely_caregiver/screens/profile_screens/profile_screen/controller/profile_screen_controller.dart';
import 'package:carely_caregiver/screens/profile_screens/profile_screen/widgets/profile_widgets.dart';
import 'package:carely_caregiver/widgets/default_background_template.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ── Menu Item Model ──────────────────────────────────────
class ProfileMenuItem {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const ProfileMenuItem({required this.icon, required this.title, this.onTap});
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileScreenController controller =
        Get.find<ProfileScreenController>();
    final isClient = selectedAppUserType == AppUserType.client;

    // ── Client Account items ──
    final List<ProfileMenuItem> clientAccountItems = [
      ProfileMenuItem(
        icon: Icons.person_outline_rounded,
        title: 'Personal Information',
        onTap: () {
          Get.toNamed(AppRoutes.instance.personalInfoScreen);
        },
      ),
      ProfileMenuItem(
        icon: Icons.favorite_border_rounded,
        title: 'Care Recipients',
        onTap: () {
          Get.toNamed(AppRoutes.instance.careRecipientsScreen);
        },
      ),
    ];

    // ── Caregiver Account items ──
    final List<ProfileMenuItem> caregiverAccountItems = [
      ProfileMenuItem(
        icon: Icons.person_outline_rounded,
        title: 'Personal Information',
        onTap: () {
          Get.toNamed(AppRoutes.instance.personalInfoScreen);
        },
      ),
      ProfileMenuItem(
        icon: Icons.calendar_today_outlined,
        title: 'Availability & Schedule',
        onTap: () {
          Get.toNamed(AppRoutes.instance.availabilityScreen);
        },
      ),
      ProfileMenuItem(
        icon: Icons.description_outlined,
        title: 'Documents & Verification',
        onTap: () {},
      ),
    ];

    // ── Common Settings items ──
    final List<ProfileMenuItem> settingsItems = [
      ProfileMenuItem(
        icon: Icons.notifications_none_rounded,
        title: 'Notifications',
        onTap: () {},
      ),
      ProfileMenuItem(
        icon: Icons.lock_outline_rounded,
        title: 'Privacy Policy',
        onTap: () {
          Get.toNamed(AppRoutes.instance.privacyPolicy);
        },
      ),
      ProfileMenuItem(
        icon: Icons.description_outlined,
        title: 'Terms of Service',
        onTap: () {
          Get.toNamed(AppRoutes.instance.termsAndConditions);
        },
      ),
    ];

    return DefaultBackgroundTemplate(
      appBarTitle: 'Profile',
      hideBackButton: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──
            Obx(
              () => ProfileAvatarHeader(
                name: controller.name.value,
                memberSince: controller.memberSince.value,
                avatarUrl: controller.avatarUrl.value,
                showCameraIcon: isClient,
              ),
            ),
            const SizedBox(height: 32),

            // ── Account Section ──
            ProfileSection(
              title: 'Account',
              items: isClient ? clientAccountItems : caregiverAccountItems,
            ),
            const SizedBox(height: 24),

            // ── Settings Section ──
            ProfileSection(
              title: 'Settings',
              items: settingsItems,
            ),
            const SizedBox(height: 32),

            // ── Logout ──
            LogoutButton(onTap: controller.logout),
          ],
        ),
      ),
    );
  }
}
