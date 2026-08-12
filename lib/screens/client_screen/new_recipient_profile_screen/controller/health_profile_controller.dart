import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HealthProfileController extends GetxController {
  final nameController = TextEditingController();
  final healthNeedsController = TextEditingController();

  final Rxn<String> selectedRelationship = Rxn<String>();
  final Rxn<File> profileImage = Rxn<File>();

  final List<String> relationships = [
    'Parent',
    'Spouse',
    'Sibling',
    'Friend',
    'Other',
  ];

  void saveRecipient() {
    // Implement save logic here
    Get.snackbar('Success', 'Profile created successfully!');
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
