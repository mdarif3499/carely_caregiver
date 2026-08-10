import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HealthProfileController extends GetxController {
  final nameController = TextEditingController(text: 'Sarah Henderson');
  final dobController = TextEditingController();
  final medicalController = TextEditingController();

  final RxString selectedGender = 'Select'.obs;
  final RxString selectedLanguage = 'English'.obs;

  final List<String> genders = ['Male', 'Female', 'Other'];
  final List<String> languages = ['English', 'Spanish', 'Other'];

  void saveRecipient() {
    Get.back();
    Get.snackbar('Success', 'Recipient added successfully!');
  }

  void cancel() {
    Get.back();
  }

  @override
  void onClose() {
    // Let GetX handle memory cleanup to avoid "used after disposed" errors 
    // during screen exit animations.
    super.onClose();
  }
}
