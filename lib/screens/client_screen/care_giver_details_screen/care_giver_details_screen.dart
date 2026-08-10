import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:carely_caregiver/constant/app_constant.dart';
import 'package:carely_caregiver/screens/client_screen/care_giver_details_screen/controller/care_giver_details_controller.dart';
import 'package:carely_caregiver/widgets/default_background_template.dart';
import 'package:carely_caregiver/widgets/profile_avatar/profile_avatar.dart';
import 'package:carely_caregiver/widgets/text/primary_text.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../gen/assets.gen.dart';

class CareGiverDetailsScreen extends StatelessWidget {
  const CareGiverDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    CareGiverDetailsController controller =
        Get.find<CareGiverDetailsController>();

    return DefaultBackgroundTemplate(
      appBarTitle: 'Caregiver Profile',
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment:CrossAxisAlignment .center,
            children: [
              ProfileAvatar(
                size: 160.w,
                imageUrl:
                    "https://media.istockphoto.com/id/1468678624/photo/nurse-hospital-employee-and-portrait-of-black-man-in-a-healthcare-wellness-and-clinic-feeling.jpg?s=612x612&w=0&k=20&c=AGQPyeEitUPVm3ud_h5_yVX4NKY9mVyXbFf50ZIEtQI=",
                borderColor: AppColors.instance.secondaryColor,
                badgeIcon: Assets.icons.verify,
                badgeSize: 40.w,
              ),
              12.height,
              CommonText(
                text: 'Sarah Jenkins, RN',
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
              8.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CommonImage(
                    src: Assets.icons.starIcon,
                    height: 20,
                    width: 20,
                  ),
                  4.width,
                  RichText(
                    text: TextSpan(
                      text: '4.9 ',
                      style: TextStyle(
                        fontSize: 18.h,
                        fontWeight: FontWeight.w700,
                        color: AppColors.instance.primaryTextColor,
                        fontFamily: AppConstant.instance.font,
                      ),
                      children: [
                        TextSpan(
                          text: '(120 reviews)',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: AppColors.instance.subTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              8.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CommonImage(
                    src: Assets.icons.location,
                    height: 20,
                    width: 20,
                  ),
                  4.width,
                  CommonText(
                    text: 'New York, NY',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    textColor: AppColors.instance.subTextColor,
                  ),
                ],
              ),
              24.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _caregiverCard(title: 'Jobs', value: '150+'),
                  _caregiverCard(title: 'EXP.', value: '8 Yrs'),
                  _caregiverCard(title: 'RESPONSE', value: '<10m'),
                ],
              ),
              24.height,
              Align(
                alignment: Alignment.centerLeft,
                child: AppContentHeader(
                  text: 'Bio',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              8.height,
              AppSecondaryText(
                fontWeight: FontWeight.w200,
                fontSize: 18,
                text:
                    'Compassionate Registered Nurse with over 8 years of experience in geriatric care and post-operative recovery. I specialize in providing high-quality, personalized support for your loved ones, ensuring they maintain their dignity and independence at home.',
              ),
              24.height,
              Align(
                alignment: Alignment.centerLeft,
                child: AppContentHeader(
                  text: 'Specialties',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              8.height,
              Align(
                alignment: Alignment.centerLeft,
                child: Obx(
                  () => Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 0,
                    runSpacing: 0,
                    children: controller.specialties
                        .map((s) => _specialtiesCard(title: s))
                        .toList(),
                  ),
                ),
              ),
              24.height,
              Align(
                alignment: Alignment.centerLeft,
                child: AppContentHeader(
                  text: 'UpComing Availability',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),

              8.height,
              Obx(
                () => SingleChildScrollView(
                  scrollDirection: Axis
                      .horizontal,
                  child: Row(
                    children: controller.availability
                        .map(
                          (a) => _availabilityCard(
                            day: a.day,
                            date: a.date,
                            availableStatus: a.status,
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              48.height,
              CommonButton(
                titleText: 'Book Appointment',
                onTap: () {},
                buttonWidth: double.infinity,
              ),
              20.height,
            ],
          ),
        ),
      ),
    );
  }

  Widget _specialtiesCard({required String title}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.instance.secondaryColor.withAlpha(50),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: CommonText(text: title, fontSize: 16),
        ),
      ),
    );
  }

  Widget _caregiverCard({required String title, required String value}) {
    return Container(
      height: 100.h,
      width: 112.w,
      decoration: BoxDecoration(
        color: AppColors.instance.boxBg,
        border: Border.all(color: AppColors.instance.secondaryColor, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 26),
        child: Column(
          children: [
            CommonText(
              text: title,
              fontWeight: FontWeight.w500,
              fontSize: 16,
              textColor: AppColors.instance.secondaryText,
            ),
            6.height,
            CommonText(
              text: value,
              fontWeight: FontWeight.w700,
              fontSize: 24,
              textColor: AppColors.instance.primaryTextColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _availabilityCard({
    required String day,
    required String date,
    required String availableStatus,
  }) {
    bool isAvailable = availableStatus == 'Available';
    final borderColor = isAvailable
        ? AppColors.instance.primary
        : AppColors.instance.secondaryText;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 96.h,
        width: 108.w,
        decoration: BoxDecoration(
          color: isAvailable
              ? AppColors.instance.primary.withAlpha(15)
              : AppColors.instance.boxBg,
          border: Border.all(color: borderColor, width: 1.5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CommonText(
              text: day,
              fontWeight: FontWeight.w500,
              fontSize: 12,
              textColor: AppColors.instance.secondaryText,
            ),
            4.height,
            CommonText(
              text: date,
              fontWeight: FontWeight.w700,
              fontSize: 16,
              textColor: borderColor,
            ),
            6.height,
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: borderColor.withAlpha(30),
                borderRadius: BorderRadius.circular(20),
              ),
              child: CommonText(
                text: availableStatus,
                fontWeight: FontWeight.w600,
                fontSize: 10,
                textColor: borderColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
