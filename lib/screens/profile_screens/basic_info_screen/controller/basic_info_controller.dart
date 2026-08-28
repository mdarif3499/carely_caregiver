import 'dart:io';
import 'package:carely_caregiver/repositories/user_repository.dart';
import 'package:carely_caregiver/widgets/show_custom_snackbar.dart';
import 'package:carely_caregiver/services/share_pref_helper/share_pref_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';

class BasicInfoController extends GetxController{
  RxBool isClient = false.obs;
  
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  Rxn<File> profileImage = Rxn<File>();
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    final args = Get.arguments;
    if (args != null && args is Map) {
      isClient.value = args["isClient"] ?? false;
      fullNameController.text = args["name"] ?? "";
      emailController.text = args["email"] ?? "";
      phoneController.text = args["phone"] ?? "";
    }
    _loadStoredData();
    super.onInit();
  }

  Future<void> _loadStoredData() async {
    if (phoneController.text.isEmpty) {
      phoneController.text = await SharePrefsHelper.getString(SharedPreferenceValue.phone);
    }
    if (emailController.text.isEmpty) {
      emailController.text = await SharePrefsHelper.getString(SharedPreferenceValue.email);
    }
  }

  Future<void> updateProfile() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;
      update();

      final response = await UserRepository.instance.updateProfile(
        name: fullNameController.text.trim(),
        phone: phoneController.text.trim(),
        intakeCompleted: true,
        profileImage: profileImage.value,
      );

      if (response.isSuccess) {
        showCustomSnackbar(message: response.message, isError: false);
        if (isClient.value) {
          Get.toNamed(AppRoutes.instance.newRecipientProfileScreen);
        } else {
          Get.toNamed(AppRoutes.instance.profileSetUpScreen);
        }
      } else {
        showCustomSnackbar(message: response.message, isError: true);
      }
    } catch (e) {
      showCustomSnackbar(message: "Failed to update profile", isError: true);
    } finally {
      isLoading.value = false;
      update();
    }
  }

}