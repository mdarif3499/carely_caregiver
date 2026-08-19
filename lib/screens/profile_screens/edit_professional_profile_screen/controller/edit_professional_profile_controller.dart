import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carely_caregiver/repositories/caregiver_repository.dart';
import 'package:carely_caregiver/repositories/user_repository.dart';
import 'package:carely_caregiver/widgets/show_custom_snackbar.dart';

class EditProfessionalProfileController extends GetxController {
  // ── Text Controllers ──
  late final TextEditingController bioController;
  late final TextEditingController hourlyRateController;
  late final TextEditingController cityController;
  late final TextEditingController stateController;
  late final TextEditingController countryController;

  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();
    bioController = TextEditingController();
    hourlyRateController = TextEditingController();
    cityController = TextEditingController();
    stateController = TextEditingController();
    countryController = TextEditingController();
    fetchProfileData();
  }

  @override
  void onClose() {
    bioController.dispose();
    hourlyRateController.dispose();
    cityController.dispose();
    stateController.dispose();
    countryController.dispose();
    super.onClose();
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

  void toggleSkill(String skill) {
    if (selectedSkills.contains(skill)) {
      selectedSkills.remove(skill);
    } else {
      selectedSkills.add(skill);
    }
  }

  // ── Specialties ──
  final List<String> allSpecialties = [
    'Dementia Care',
    'Post-Surgical',
    'Elderly Care',
    'Memory Care',
    'Daily Living',
  ];
  final RxSet<String> selectedSpecialties = <String>{}.obs;

  void toggleSpecialty(String specialty) {
    if (selectedSpecialties.contains(specialty)) {
      selectedSpecialties.remove(specialty);
    } else {
      selectedSpecialties.add(specialty);
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

  Future<void> fetchProfileData() async {
    try {
      isLoading.value = true;
      update();

      final response = await UserRepository.instance.getMyProfile();
      if (response.isSuccess) {
        final userData = response.data['data'] ?? {};
        final caregiverProfile = userData['caregiverProfile'] ?? {};

        bioController.text = caregiverProfile['bio'] ?? "";
        hourlyRateController.text = (caregiverProfile['hourlyRate'] ?? "").toString();
        cityController.text = caregiverProfile['city'] ?? "";
        stateController.text = caregiverProfile['state'] ?? "";
        countryController.text = caregiverProfile['country'] ?? "";

        if (caregiverProfile['skills'] != null) {
          selectedSkills.addAll(List<String>.from(caregiverProfile['skills']));
        }
        if (caregiverProfile['specialties'] != null) {
          selectedSpecialties.addAll(List<String>.from(caregiverProfile['specialties']));
        }

        final exp = caregiverProfile['experience'];
        if (exp != null) {
           // Find matching option or set default
           for (var option in experienceOptions) {
             if (option.contains(exp.toString())) {
               selectedExperience.value = option;
               break;
             }
           }
        }
      }
    } catch (e) {
      debugPrint("Error fetching profile: $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> updateProfile() async {
    if (isSubmitting.value) return;

    try {
      isSubmitting.value = true;
      update();

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
        Get.back();
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
