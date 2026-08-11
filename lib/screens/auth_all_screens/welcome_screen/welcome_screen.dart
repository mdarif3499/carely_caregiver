import 'package:carely_caregiver/routes/app_routes.dart';
import 'package:carely_caregiver/widgets/default_background_template.dart';
import 'package:carely_caregiver/widgets/role_card.dart';
import 'package:carely_caregiver/widgets/text/primary_text.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  AuthScreenHeader(text: 'Choose your role'),
                  8.height,
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0, right: 30),
                    child: AppSecondaryText(
                      textAlign: TextAlign.center,
                      text:
                          "Let's get started by selecting how you want to use the app.",
                    ),
                  ),
                  36.height,

                  Obx(
                    () => RoleCard(
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
                  ),
                  32.height,
                  Obx(
                    () => RoleCard(
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
                  ),
                  48.height,
                  Obx(
                    () => CommonButton(
                      isLoading: controller.isLoading.value,
                      titleText: 'Next Step',
                      onTap: () {
                        if (controller.selectedIndex.value != -1 && !controller.isLoading.value) {
                          controller.registerUser();
                        }
                      },
                      buttonWidth: double.infinity,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
