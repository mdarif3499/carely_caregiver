import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:carely_caregiver/repositories/caregiver_repository.dart';
import 'package:carely_caregiver/widgets/show_custom_snackbar.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../models/category_model.dart';
import '../../../../routes/app_routes.dart';

class ProfileSetupScreenController extends GetxController {
  // ── Text Controllers ──
  late final TextEditingController bioController;
  late final TextEditingController hourlyRateController;
  late final TextEditingController cityController;
  late final TextEditingController stateController;
  late final TextEditingController countryController;

  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _setPlaceholder();
    bioController = TextEditingController();
    hourlyRateController = TextEditingController();
    cityController = TextEditingController();
    stateController = TextEditingController();
    countryController = TextEditingController();
    fetchCategories();
  }

  void _setPlaceholder() {
    // Shimmer template data
    if (categories.isEmpty) {
      categories.value = List.generate(4, (index) => CategoryModel(id: 'p$index', name: 'Specialty $index', description: ''));
    }
  }


  // ── Skills ──
  final List<String> allSkills = [
    'Elder Care',
    'First Aid',
    'Memory Care',
    'Mobility Support',
    'Medication Admin',
    'Meal Prep',
  ];

  final RxSet<String> selectedSkills = <String>{}.obs;
  final RxBool showAllSkills = false.obs;
  static const int collapsedCount = 4;

  List<String> get visibleSkills {
    if (showAllSkills.value || allSkills.length <= collapsedCount) {
      return allSkills;
    }
    return allSkills.take(collapsedCount).toList();
  }

  bool get hasMoreSkills =>
      !showAllSkills.value && allSkills.length > collapsedCount;

  void toggleSkill(String skill) {
    if (selectedSkills.contains(skill)) {
      selectedSkills.remove(skill);
    } else {
      selectedSkills.add(skill);
    }
  }

  void expandSkills() => showAllSkills.value = true;

  // ── Specialties ──
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxSet<String> selectedSpecialties = <String>{}.obs;

  Future<void> fetchCategories() async {
    try {
      final response = await CaregiverRepository.instance.getCategories();
      if (response.isSuccess) {
        final List data = response.data['data'] ?? [];
        categories.value = data.map((e) => CategoryModel.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint("Error fetching categories: $e");
    }
  }

  void toggleSpecialty(String categoryId) {
    if (selectedSpecialties.contains(categoryId)) {
      selectedSpecialties.remove(categoryId);
    } else {
      selectedSpecialties.add(categoryId);
    }
  }

  // ── Work Experience ──
  final List<String> experienceOptions = [
    '0 – 1 year',
    '1 – 2 years',
    '2 – 5 years',
    '5 – 10 years',
    '10+ years',
  ];

  final Rxn<String> selectedExperience = Rxn<String>();

  void onExperienceChanged(String? val) => selectedExperience.value = val;

  // ── Certifications ──
  final RxList<Map<String, dynamic>> certifications = <Map<String, dynamic>>[].obs;
  final RxBool isUploading = false.obs;
  final RxBool isSubmitting = false.obs;

  Future<void> pickAndUploadFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      );

      if (result != null && result.files.single.path != null) {
        File file = File(result.files.single.path!);
        String fileName = result.files.single.name;
        
        await uploadFile(file, fileName);
      }
    } catch (e) {
      showCustomSnackbar(message: "Error picking file: $e", isError: true);
    }
  }

  Future<void> uploadFile(File file, String fileName) async {
    try {
      isUploading.value = true;
      update();

      final response = await CaregiverRepository.instance.uploadDocument(
        documentType: "NURSING_CERT",
        file: file,
      );

      if (response.isSuccess) {
        final uploadedData = response.data['data'];
        
        certifications.add({
          'title': fileName,
          'subtitle': 'Uploaded successfully',
          'data': uploadedData,
        });
        
        showCustomSnackbar(message: "File uploaded successfully", isError: false);
      } else {
        showCustomSnackbar(message: response.message, isError: true);
      }
    } catch (e) {
      showCustomSnackbar(message: "Upload failed: $e", isError: true);
    } finally {
      isUploading.value = false;
      update();
    }
  }

  void deleteCertification(int index) => certifications.removeAt(index);

  Future<void> updateProfile() async {
    if (isSubmitting.value) return;

    if (selectedExperience.value == null) {
      showCustomSnackbar(message: "Please select years of experience", isError: true);
      return;
    }

    try {
      isSubmitting.value = true;
      update();

      // Mapping UI data to API fields
      int? expYears;
      if (selectedExperience.value != null) {
        final match = RegExp(r'(\d+)').firstMatch(selectedExperience.value!);
        if (match != null) {
          expYears = int.parse(match.group(0)!);
        }
      }

      final Map<String, dynamic> profileData = {
        "bio": bioController.text.trim(),
        "specialties": selectedSpecialties.toList(),
        "skills": selectedSkills.toList(),
        "experience": expYears,
        "hourlyRate": double.tryParse(hourlyRateController.text.trim()) ?? 0,
        "city": cityController.text.trim(),
        "state": stateController.text.trim(),
        "country": countryController.text.trim(),
      };

      final response = await CaregiverRepository.instance.updateProfile(profileData: profileData);

      if (response.isSuccess) {
        showCustomSnackbar(message: "Profile updated successfully", isError: false);
        Get.offAllNamed(
          AppRoutes.instance.appNavigationScreen,
          arguments: {"isClient": false, "selectedIndex": 3},
        );
      } else {
        showCustomSnackbar(message: response.message, isError: true);
      }
    } catch (e) {
      showCustomSnackbar(message: "Failed to update profile: $e", isError: true);
    } finally {
      isSubmitting.value = false;
      update();
    }
  }
}
