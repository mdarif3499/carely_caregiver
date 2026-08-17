import 'dart:io';
import 'package:carely_caregiver/repositories/caregiver_repository.dart';
import 'package:carely_caregiver/widgets/show_custom_snackbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';

class ProfileSetupScreenController extends GetxController {
  // ── Skills & Specializations ──
  final List<String> allSkills = [
    'Elder Care',
    'First Aid',
    'Memory Care',
    'Mobility Support',
    'Medication Admin',
  ];

  final RxSet<String> selectedSkills = <String>{'Elder Care', 'First Aid'}.obs;
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
      final PlatformFile? result = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      );

      if (result != null && result.path != null) {
        File file = File(result.path!);
        String fileName = result.name;
        
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
        // Assuming the response data contains the uploaded file info
        final uploadedData = response.data['data'];
        
        certifications.add({
          'title': fileName,
          'subtitle': 'Uploaded successfully',
          'data': uploadedData, // Store the response for later use if needed
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

      // Mapping UI data to API fields (Number extraction for experience)
      int? expYears;
      if (selectedExperience.value != null) {
        final match = RegExp(r'(\d+)').firstMatch(selectedExperience.value!);
        if (match != null) {
          expYears = int.parse(match.group(0)!);
        }
      }

      // Create payload dynamically - only send what is available
      final Map<String, dynamic> profileData = {};
      
      if (selectedSkills.isNotEmpty) {
        profileData["skills"] = selectedSkills.toList();
      }
      
      if (expYears != null) {
        profileData["experience"] = expYears;
      }

      // Ensure we have at least something to send
      if (profileData.isEmpty) {
        showCustomSnackbar(message: "Please select your professional details", isError: true);
        return;
      }

      final response = await CaregiverRepository.instance.updateProfile(profileData: profileData);

      if (response.isSuccess) {
        showCustomSnackbar(message: "Profile updated successfully", isError: false);
        Get.offAllNamed(
          AppRoutes.instance.appNavigationScreen,
          arguments: {"isClient": false},
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
