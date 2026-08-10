import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PersonalInfoController extends GetxController {
  final nameController = TextEditingController(text: 'Sarah Henderson');
  final emailController = TextEditingController(text: 'sarah.m@carefamily.com');
  final phoneController = TextEditingController(text: '(555) 012-3456');
  final medicalController = TextEditingController();

  final RxString avatarUrl = 'https://images.unsplash.com/photo-1594824476967-48c8b964273f?q=80&w=1000&auto=format&fit=crop'.obs;

  void saveChanges() {
    Get.back();
    Get.snackbar('Success', 'Profile updated successfully!');
  }

  @override
  void onClose() {
    // Let GetX handle memory cleanup to avoid "used after disposed" errors 
    // during screen exit animations.
    super.onClose();
  }
}
