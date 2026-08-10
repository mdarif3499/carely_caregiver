import 'package:carely_caregiver/screens/client_screen/select_service_type_screen/controller/selected_service_type_controller.dart';
import 'package:carely_caregiver/screens/client_screen/select_service_type_screen/widgets/service_type_card.dart';
import 'package:carely_caregiver/widgets/default_background_template.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constant/app_colors.dart';

class SelectServiceTypeScreen extends StatelessWidget {
  const SelectServiceTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SelectedServiceTypeController controller =
        Get.find<SelectedServiceTypeController>();
    final colors = AppColors.instance;

    return DefaultBackgroundTemplate(
      appBarTitle: 'Select Service Type',
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CommonText(
                    text: 'What type of care is needed?',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                  const SizedBox(height: 8),
                  CommonText(
                    text: "Choose the service that best matches your loved one's requirements.",
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    textColor: colors.secondaryText,
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 24),
                  Obx(
                    () => Column(
                      children: List.generate(controller.serviceTypes.length, (index) {
                        final item = controller.serviceTypes[index];
                        final isSelected = controller.selectedIndex.value == index;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: ServiceTypeCard(
                            title: item.title,
                            description: item.description,
                            icon: item.icon,
                            isSelected: isSelected,
                            onTap: () => controller.selectType(index),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: CommonButton(
              titleText: 'Next',
              onTap: controller.onContinue,
              buttonWidth: double.infinity,
            ),
          ),
        ],
      ),
    );
  }
}
