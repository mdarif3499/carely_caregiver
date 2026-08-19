import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:carely_caregiver/screens/client_screen/find_caregiver_screen/controller/find_caregiver_controller.dart';
import 'package:carely_caregiver/screens/client_screen/find_caregiver_screen/widgets/find_caregiver_widgets.dart';
import 'package:carely_caregiver/widgets/default_background_template.dart';
import 'package:carely_caregiver/widgets/home_widgets.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FindCaregiverScreen extends StatelessWidget {
  const FindCaregiverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FindCaregiverController>();
    final colors = AppColors.instance;

    return DefaultBackgroundTemplate(
      appBarTitle: 'Find Caregivers',
      hideBackButton: true,
      actions: [
        AppIconButton(icon: Icons.tune_rounded, onTap: controller.onFilterTap),
        const SizedBox(width: 12),
      ],
      child: Obx(() {
        final caregivers = controller.caregivers;

        // ── Header (Search + Category Filters) ──
        final header = Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeSearchBar(onChanged: controller.onSearchChanged),
              const SizedBox(height: 20),
              CaregiverFilterRow(
                categories: controller.filterCategories,
                selected: controller.selectedFilter.value,
                onSelected: controller.onFilterSelected,
              ),
              const SizedBox(height: 24),
              CommonText(
                text: controller.isLoading.value 
                    ? 'Finding caregivers...' 
                    : '${caregivers.length} caregivers nearby',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                textColor: colors.textPrimary,
              ),
            ],
          ),
        );

        if (controller.isLoading.value && caregivers.isEmpty) {
          return Column(
            children: [
              header,
              const Expanded(
                child: Center(child: CircularProgressIndicator()),
              ),
            ],
          );
        }

        if (caregivers.isEmpty) {
          return Column(
            children: [
              header,
              const EmptySearchState(),
            ],
          );
        }

        return SmartListLoader(
          itemCount: caregivers.length,
          appbar: header,
          onColapsAppbar: Container(
            color: colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            child: CaregiverFilterRow(
              categories: controller.filterCategories,
              selected: controller.selectedFilter.value,
              onSelected: controller.onFilterSelected,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemBuilder: (_, index) {
            return CaregiverCard(caregiver: caregivers[index]);
          },
        );
      }),
    );
  }
}
