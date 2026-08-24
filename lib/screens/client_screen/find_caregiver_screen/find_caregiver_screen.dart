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
      child: Column(
        children: [
          // ── Header (Search + Category Filters) ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeSearchBar(
                  controller: controller.searchController,
                  onChanged: controller.onSearchChanged,
                ),
                const SizedBox(height: 20),
                Obx(() => CaregiverFilterRow(
                  categories: controller.filterCategoryNames,
                  selected: controller.selectedFilterName.value,
                  onSelected: controller.onFilterSelected,
                )),
                const SizedBox(height: 24),
                Obx(() => CommonText(
                  text: controller.isLoading.value && controller.caregivers.isEmpty
                      ? 'Finding caregivers...' 
                      : '${controller.caregivers.length} caregivers nearby',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  textColor: colors.textPrimary,
                )),
              ],
            ),
          ),

          // ── Caregiver List ──
          Expanded(
            child: Obx(() {
              final caregivers = controller.caregivers;

              if (controller.isLoading.value && caregivers.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (caregivers.isEmpty) {
                return const EmptySearchState();
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                itemCount: caregivers.length,
                itemBuilder: (_, index) {
                  return CaregiverCard(caregiver: caregivers[index]);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
