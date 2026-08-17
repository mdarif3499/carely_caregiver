import 'dart:io';
import 'package:carely_caregiver/repositories/user_repository.dart';
import 'package:carely_caregiver/screens/profile_screens/profile_screen/controller/profile_screen_controller.dart';
import 'package:carely_caregiver/widgets/show_custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PersonalInfoController extends GetxController {
  final ProfileScreenController profileController = Get.find();
  
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final medicalController = TextEditingController();

  final Rxn<File> pickedImage = Rxn<File>();
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    final user = profileController.userModel.value;
    if (user != null) {
      nameController.text = user.name;
      emailController.text = user.email;
      phoneController.text = user.phone;
    }
    super.onInit();
  }

  Future<void> pickProfileImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      pickedImage.value = File(image.path);
    }
  }

  Future<void> saveChanges() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;
      update();

      final response = await UserRepository.instance.updateProfile(
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
        intakeCompleted: true,
        profileImage: pickedImage.value,
      );

      if (response.isSuccess) {
        showCustomSnackbar(message: response.message, isError: false);
        // Refresh global profile data
        await profileController.fetchProfile();
        Get.back();
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

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    medicalController.dispose();
    super.onClose();
  }
}
