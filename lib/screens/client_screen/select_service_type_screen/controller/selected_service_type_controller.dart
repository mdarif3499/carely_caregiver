import 'package:carely_caregiver/routes/app_routes.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../../repositories/caregiver_repository.dart';

// ── Data Model ───────────────────────────────────────────
class ServiceTypeModel {
  final String id;
  final String title;
  final String description;
  final String icon;

  const ServiceTypeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
  });

  factory ServiceTypeModel.fromJson(Map<String, dynamic> json) {
    return ServiceTypeModel(
      id: json['_id'] ?? '',
      title: json['name'] ?? 'Unknown Service',
      description: json['description'] ?? 'No description provided.',
      icon: 'assets/icons/medicale.svg',
    );
  }
}

// ── Controller ───────────────────────────────────────────
class SelectedServiceTypeController extends GetxController {
  final RxInt selectedIndex = 0.obs;
  final RxList<ServiceTypeModel> serviceTypes = <ServiceTypeModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      final response = await CaregiverRepository.instance.getCategories();
      if (response.isSuccess) {
        final List data = response.data['data'] ?? [];
        serviceTypes.value = data.map((e) => ServiceTypeModel.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint("Error fetching categories: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void selectType(int index) {
    selectedIndex.value = index;
  }

  void onContinue() {
    Get.toNamed(AppRoutes.instance.bookCareGiverScreen);
  }
}
