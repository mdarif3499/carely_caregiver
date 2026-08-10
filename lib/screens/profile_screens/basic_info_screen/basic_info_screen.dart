import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:carely_caregiver/routes/app_routes.dart';
import 'package:carely_caregiver/screens/auth_all_screens/login_screen/entity/auth_entity.dart';
import 'package:carely_caregiver/widgets/default_background_template.dart';
import 'package:carely_caregiver/widgets/phone_number_text_filed.dart';
import 'package:carely_caregiver/widgets/text/primary_text.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/basic_info_controller.dart';

class BasicInfoScreen extends StatelessWidget {
  const BasicInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final BasicInfoController controller = Get.find();

    return DefaultBackgroundTemplate(
      appBarTitle: 'Create Your Profile',
      child: Center(
        child: FormBuilder(
          entity: AuthEntity(),
          builder: (context, formKey, entity) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Obx(
                    () => AuthScreenHeader(
                      text: controller.isClient.value
                          ? 'Basic Information'
                          : "Who are you seeking care for?",
                    ),
                  ),
                  8.height,
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0, right: 24),
                    child: Obx(
                      () => AppSecondaryText(
                        textAlign: TextAlign.center,
                        text: controller.isClient.value
                            ? "Let's start with the basics to help families get to know you."
                            : "Provide details about the family member or person needing assistance to help us find the best match.",
                      ),
                    ),
                  ),
                  36.height,
                  CommonImagePicker(width: 160, height: 160, borderRadius: 80),
                  24.height,
                  AppContentHeader(text: 'Profile Photo'),
                  8.height,
                  AppSecondaryText(text: 'A clear photo helps build trust.'),
                  32.height,
                  Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        !controller.isClient.value
                            ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppContentHeader(text: 'Full Name'),
                                  12.height,
                                  CommonTextField(
                                    validationType: ValidationType.notRequired,
                                    hintText: 'Enter your full name',
                                  ),
                                  16.height,
                                  AppContentHeader(text: 'Email'),
                                  12.height,
                                  CommonTextField(
                                    validationType: ValidationType.notRequired,
                                    hintText: 'Enter your email',
                                  ),
                                  16.height,
                                  AppContentHeader(text: 'Phone Number'),
                                  12.height,
                                  PhoneTextField(),
                                ],
                              )
                            : SizedBox(),
                        controller.isClient.value
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  16.height,
                                  AppContentHeader(text: 'Recipient Full Name'),
                                  12.height,
                                  CommonTextField(
                                    validationType: ValidationType.notRequired,
                                    hintText:
                                        'Enter name of the person you care for',
                                  ),
                                  16.height,
                                  AppContentHeader(text: 'Your Relationship'),
                                  12.height,
                                  CommonDropDown(
                                    hint:
                                        'Chose your relationship with the care recipient',
                                    enableInitalSelection: false,
                                    items: [
                                      'Parent',
                                      'Spouse',
                                      'Sibling',
                                      'Friend',
                                      'Other',
                                    ],
                                    onChanged: (value) {},
                                    nameBuilder: (value) {
                                      return value;
                                    },
                                  ),
                                  16.height,
                                  AppContentHeader(
                                    text: 'Health Considerations & Care Needs',
                                  ),
                                  12.height,
                                  CommonMultilineTextField(
                                    borderColor: AppColors.instance.transparent,
                                    height: 140,
                                    validationType: ValidationType.notRequired,
                                    hintText:
                                        'List any allergies, mobility issues, or specific conditions (e.g., Diabetes, Dementia) ...',
                                  ),
                                  16.height,
                                ],
                              )
                            : SizedBox(),
                        48.height,

                        controller.isClient.value
                            ? Row(
                                children: [
                                  Expanded(
                                    child: CommonButton(
                                      buttonColor: AppColors.instance.boxBg,
                                      titleText: 'Back',
                                      titleColor:
                                          AppColors.instance.textPrimary,
                                      onTap: () {},
                                      buttonWidth: double.infinity,
                                    ),
                                  ),
                                  16.width,
                                  Expanded(
                                    child: CommonButton(
                                      titleText: 'Continue',
                                      onTap: () {
                                        Get.toNamed(AppRoutes.instance.profileSetUpScreen);
                                      },
                                      buttonWidth: double.infinity,
                                    ),
                                  ),
                                ],
                              )
                            :       CommonButton(
            titleText: 'Next Step',
            onTap: () {
              controller.isClient.value==false?Get.toNamed(AppRoutes.instance.profileSetUpScreen):null;
            },
            buttonWidth: double.infinity,
            ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
