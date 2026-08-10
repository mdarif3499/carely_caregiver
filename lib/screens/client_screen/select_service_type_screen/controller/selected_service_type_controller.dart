import 'package:carely_caregiver/routes/app_routes.dart';
import 'package:get/get.dart';

// ── Data Model ───────────────────────────────────────────
class ServiceTypeModel {
  final String title;
  final String description;
  final String icon;

  const ServiceTypeModel({
    required this.title,
    required this.description,
    required this.icon,
  });
}

// ── Controller ───────────────────────────────────────────
class SelectedServiceTypeController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  final List<ServiceTypeModel> serviceTypes = const [
    ServiceTypeModel(
      title: 'Nursing Care',
      description:
          'Skilled medical assistance by licensed RNs or LPNs for wound care, injections, and monitoring.',
      icon: 'assets/icons/medicale.svg',
    ),
    ServiceTypeModel(
      title: 'Companion Care',
      description:
          'Non-medical support, socialization, and light housekeeping to improve quality of life.',
      icon: 'assets/icons/medicale.svg',
    ),
    ServiceTypeModel(
      title: 'Physical Therapy',
      description:
          "Personalized mobility training and rehabilitation plans conducted in the comfort of home.",
      icon: 'assets/icons/medicale.svg',
    ),

  ];

  void selectType(int index) {
    selectedIndex.value = index;
  }

  void onContinue() {
    Get.toNamed(AppRoutes.instance.bookCareGiverScreen);
    // final selected = serviceTypes[selectedIndex.value];

  }
}