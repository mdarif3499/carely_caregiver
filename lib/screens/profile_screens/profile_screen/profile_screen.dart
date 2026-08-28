import 'package:carely_caregiver/app_all_enum/app_login_status.dart';
import 'package:carely_caregiver/routes/app_routes.dart';
import 'package:carely_caregiver/screens/profile_screens/profile_screen/controller/profile_screen_controller.dart';
import 'package:carely_caregiver/screens/profile_screens/profile_screen/widgets/profile_widgets.dart';
import 'package:carely_caregiver/widgets/default_background_template.dart';
import 'package:core_kit/utils/core_screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';


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
        icon: Icons.work_outline_rounded,
        title: 'Professional Profile',
        onTap: () {
          Get.toNamed(AppRoutes.instance.editProfessionalProfileScreen);
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
        onTap: () {
          Get.toNamed(AppRoutes.instance.caregiverDocumentsScreen);
        },
      ),
    ];

    // ── Common Settings items ──
    final List<ProfileMenuItem> settingsItems = [
      ProfileMenuItem(
        icon: Icons.notifications_none_rounded,
        title: 'Notifications',
        onTap: () {
          Get.toNamed(AppRoutes.instance.notificationSettingsScreen);
        },
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
      child: Obx(
        () => Skeletonizer(
          enabled: controller.isLoading.value,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Header (User Data) ──
                      ProfileAvatarHeader(
                        name: controller.userModel.value?.name ?? "...",
                        memberSince: controller.userModel.value?.memberSince ?? "...",
                        avatarUrl: controller.userModel.value?.profileImage ?? "",
                      ),
                      SizedBox(height: 32.h),

                      // ── Account Section ──
                      ProfileSection(
                        title: 'Account',
                        items: isClient ? clientAccountItems : caregiverAccountItems,
                      ),
                      SizedBox(height: 24.h),

                      // ── Settings Section ──
                      ProfileSection(
                        title: 'Settings',
                        items: settingsItems,
                      ),
                      SizedBox(height: 32.h),

                      // ── Logout ──
                      LogoutButton(onTap: controller.logout),
                    ],
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
 ///