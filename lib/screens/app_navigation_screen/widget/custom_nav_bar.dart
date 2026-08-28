import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';

import '../../../app_all_enum/app_login_status.dart';
import '../../../gen/assets.gen.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String,String>> clientIcons = [
      {Assets.icons.home: 'Home'},
      {Assets.icons.search: 'Search'},
      {Assets.icons.booking: 'Booking'},
      {Assets.icons.message: 'Message'},
      {Assets.icons.profile: 'Profile'},
    ];

    final List<Map<String,String>> clientSelectedIcons = [
      {Assets.icons.sHome: 'Home'},
      {Assets.icons.sSearch: 'Search'},
      {Assets.icons.sBooking: 'Booking'},
      {Assets.icons.sMessage: 'Message'},
      {Assets.icons.sProfile: 'Profile'},
    ];

    final List<Map<String,String>> caregiverIcons = [
      {Assets.icons.home: 'Home'},
      {Assets.icons.booking: 'Booking'},
      {Assets.icons.message: 'Message'},
      {Assets.icons.earning: 'Earning'},
      {Assets.icons.profile: 'Profile'},
    ];

    final List<Map<String,String>> careGiverSelectedIcons = [
      {Assets.icons.sHome: 'Home'},
      {Assets.icons.sBooking: 'Booking'},
      {Assets.icons.sMessage: 'Message'},
      {Assets.icons.sEarning: 'Earning'},
      {Assets.icons.sProfile: 'Profile'},
    ];

    return Container(
      decoration:const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 10,
            offset:  Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          selectedAppUserType == AppUserType.client
              ? clientIcons.length
              : caregiverIcons.length,
          (index) {
            final isSelected = currentIndex == index;
            return Expanded(
              child: InkWell(
                onTap: () => onTap(index),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Indicator Bar
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      height: 6,
                      width: isSelected ? 50 : 0,
                      decoration: BoxDecoration(
                        color: AppColors.instance.primary, // Purple indicator
                        borderRadius:const BorderRadius.only(
                          bottomLeft: Radius.circular(6),
                          bottomRight: Radius.circular(6),
                        ),
                      ),
                    ),
                    12.height,
                    // Icon
                    CommonImage(
                      src: isSelected
                          ? (selectedAppUserType == AppUserType.client
                              ? clientSelectedIcons[index].keys.first
                              : careGiverSelectedIcons[index].keys.first)
                          : (selectedAppUserType == AppUserType.client
                              ? clientIcons[index].keys.first
                              : caregiverIcons[index].keys.first),
                      width: 24.w,
                      height: 24.w,
                      // If the icon is not colorful enough, we might need to handle colors
                      // But the design shows colorful icons, so we assume SVGs are colorful
                    ),
                    4.height,
                    CommonText(
                      text: isSelected
                          ? (selectedAppUserType == AppUserType.client
                              ? clientSelectedIcons[index].values.first
                              : careGiverSelectedIcons[index].values.first)
                          : (selectedAppUserType == AppUserType.client
                              ? clientIcons[index].values.first
                              : caregiverIcons[index].values.first),
                      fontSize: 14,
                      textColor: isSelected
                          ? AppColors.instance.primary
                          : AppColors.instance.subTextColor,
                      fontWeight: isSelected? FontWeight.w600 : FontWeight.w400,
                    ),
                    30.height,
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
