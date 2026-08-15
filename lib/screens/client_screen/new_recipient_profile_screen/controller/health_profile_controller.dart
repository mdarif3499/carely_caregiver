import 'package:carely_caregiver/repositories/client_repository.dart';
import 'package:carely_caregiver/routes/app_routes.dart';
import 'package:carely_caregiver/widgets/show_custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HealthProfileController extends GetxController {
  final nameController = TextEditingController();
  final healthNeedsController = TextEditingController();

  final Rxn<String> selectedRelationship = Rxn<String>();
  final RxBool isLoading = false.obs;

  final List<String> relationships = [
    'Parent',
    'Spouse',
    'Sibling',
    'Friend',
    'Other',
  ];

  Future<void> saveRecipient() async {
    final name = nameController.text.trim();
    final relationship = selectedRelationship.value;
    final healthNeeds = healthNeedsController.text.trim();

    if (name.isEmpty || relationship == null) {
      showCustomSnackbar(message: "Please fill in all required fields", isError: true);
      return;
    }

    try {
      isLoading.value = true;
      update();

      final response = await ClientRepository.instance.createCareRecipient(
        fullName: name,
        relationship: relationship,
        medicalConditions: healthNeeds,
      );

      if (response.isSuccess) {
        showCustomSnackbar(message: response.message, isError: false);
        Get.offAllNamed(AppRoutes.instance.appNavigationScreen, arguments: {"isClient": true});
      } else {
        showCustomSnackbar(message: response.message, isError: true);
      }
    } catch (e) {
      showCustomSnackbar(message: "Failed to create care recipient", isError: true);
    } finally {
      isLoading.value = false;
      update();
    }
  }

  void cancel() {
    Get.back();
  }

  @override
  void onClose() {
    nameController.dispose();
    healthNeedsController.dispose();
    super.onClose();
  }
}
