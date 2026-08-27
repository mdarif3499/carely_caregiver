import 'package:carely_caregiver/widgets/default_background_template.dart';
import 'package:carely_caregiver/widgets/role_card.dart';
import 'package:carely_caregiver/widgets/text/primary_text.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../gen/assets.gen.dart';
import 'controller/welcome_screen_controller.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultBackgroundTemplate(
      appBarTitle: 'Welcome',
      child: GetBuilder<WelcomeScreenController>(
        init: WelcomeScreenController(),
        builder: (controller) {
          return Obx(
            () => Skeletonizer(
              enabled: controller.isLoading.value,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16.0.r),
                  child: Column(
                    children: [
                      AuthScreenHeader(text: 'Choose your role'),
                      8.height,
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.w),
                        child: AppSecondaryText(
                          textAlign: TextAlign.center,
                          text:
                              "Let's get started by selecting how you want to use the app.",
                        ),
                      ),
                      36.height,
                      RoleCard(
                        isSelected: controller.selectedIndex.value == 0,
                        onTap: () {
                          if (!controller.isLoading.value) {
                            controller.selectedIndex.value = 0;
                            controller.registerUser();
                          }
                        },
                        iconImage: Assets.icons.caregiver,
                        title: 'I am a Caregiver',
                        description:
                            "I want to provide care, find shifts, and manage my schedule efficiently.",
                      ),
                      32.height,
                      RoleCard(
                        isSelected: controller.selectedIndex.value == 1,
                        onTap: () {
                          if (!controller.isLoading.value) {
                            controller.selectedIndex.value = 1;
                            controller.registerUser();
                          }
                        },
                        iconImage: Assets.icons.client,
                        title: 'I am a Client',
                        description:
                            "I am looking for professional care for myself or a loved one at home.",
                      ),
                      48.height,
                      CommonButton(
                        isLoading: controller.isLoading.value,
                        titleText: 'Next Step',
                        buttonHeight: 54.h,
                        buttonWidth: double.infinity,
                        buttonRadius: 14.r,
                        onTap: () {
                          if (controller.selectedIndex.value != -1 && !controller.isLoading.value) {
                            controller.registerUser();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
