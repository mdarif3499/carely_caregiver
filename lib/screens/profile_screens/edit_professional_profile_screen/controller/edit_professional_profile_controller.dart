import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carely_caregiver/repositories/caregiver_repository.dart';
import 'package:carely_caregiver/widgets/show_custom_snackbar.dart';
import '../../../../models/category_model.dart';

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
    initData();
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

  Future<void> initData() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;
      final responses = await Future.wait([
        CaregiverRepository.instance.getCategories(),
        CaregiverRepository.instance.getMyCaregiverProfile(),
      ]);
      final categoriesResponse = responses[0];
      final profileResponse = responses[1];

      if (categoriesResponse.isSuccess) {
        final rawCategories = categoriesResponse.data['data'];
        if (rawCategories is List) {
          categories.value = rawCategories
              .whereType<Map>()
              .map((category) =>
                  CategoryModel.fromJson(Map<String, dynamic>.from(category)))
              .toList();
        }
      } else {
        showCustomSnackbar(
          message: 'Failed to load specialties: ${categoriesResponse.message}',
          isError: true,
        );
      }

      if (profileResponse.isSuccess) {
        _populateProfile(profileResponse.data['data']);
      } else {
        showCustomSnackbar(
          message:
              'Failed to load professional profile: ${profileResponse.message}',
          isError: true,
        );
      }
    } catch (e) {
      showCustomSnackbar(
        message: 'Failed to load professional profile: $e',
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ── Skills ──
  final RxList<String> allSkills = <String>[
    'Elder Care',
    'First Aid',
    'Memory Care',
    'Mobility Support',
    'Medication Admin',
    'Meal Prep',
  ].obs;

  final RxSet<String> selectedSkills = <String>{}.obs;

  bool isSkillSelected(String skill) {
    final cleanSkill = skill.trim().toLowerCase();
    return selectedSkills.any((s) => s.trim().toLowerCase() == cleanSkill);
  }

  void toggleSkill(String skill) {
    final cleanSkill = skill.trim().toLowerCase();
    if (isSkillSelected(skill)) {
      selectedSkills.removeWhere((s) => s.trim().toLowerCase() == cleanSkill);
    } else {
      selectedSkills.add(skill.trim());
    }
  }

  void addCustomSkill(String skill) {
    final cleanSkill = skill.trim();
    if (cleanSkill.isNotEmpty) {
      bool existsInAll = allSkills
          .any((s) => s.trim().toLowerCase() == cleanSkill.toLowerCase());
      if (!existsInAll) {
        allSkills.add(cleanSkill);
      }
      selectedSkills.add(cleanSkill);
    }
  }

  // ── Specialties ──
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxSet<String> selectedSpecialties = <String>{}.obs;

  bool isSpecialtySelected(CategoryModel category) {
    final catId = category.id.trim().toLowerCase();
    final catName = category.name.trim().toLowerCase();
    return selectedSpecialties.any((s) {
      final cleanS = s.trim().toLowerCase();
      return (catId.isNotEmpty && cleanS == catId) ||
          (catName.isNotEmpty && cleanS == catName);
    });
  }

  void toggleSpecialty(CategoryModel category) {
    final catId = category.id;
    final catName = category.name;
    if (isSpecialtySelected(category)) {
      selectedSpecialties.removeWhere((s) {
        final cleanS = s.trim().toLowerCase();
        return (catId.isNotEmpty && cleanS == catId.trim().toLowerCase()) ||
            (catName.isNotEmpty && cleanS == catName.trim().toLowerCase());
      });
    } else {
      if (catId.isNotEmpty && !catId.startsWith('p')) {
        selectedSpecialties.add(catId);
      } else if (catName.isNotEmpty) {
        selectedSpecialties.add(catName);
      }
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

  void _populateProfile(dynamic rawData) {
    if (rawData is! Map) {
      throw const FormatException('Invalid caregiver profile response');
    }
    final Map<String, dynamic> caregiverProfile =
        rawData['caregiverProfile'] is Map
            ? Map<String, dynamic>.from(rawData['caregiverProfile'])
            : Map<String, dynamic>.from(rawData);

    bioController.text = (caregiverProfile['bio'] ?? '').toString();
    hourlyRateController.text =
        (caregiverProfile['hourlyRate'] ?? '').toString();
    cityController.text = (caregiverProfile['city'] ?? '').toString();
    stateController.text = (caregiverProfile['state'] ?? '').toString();
    countryController.text = (caregiverProfile['country'] ?? '').toString();

    // ── Parse Skills ──
    selectedSkills.clear();
    final rawSkills = caregiverProfile['skills'];
    if (rawSkills is List) {
      for (var item in rawSkills) {
        if (item != null) {
          String skillStr = item.toString().trim();
          if (skillStr.isNotEmpty) {
            selectedSkills.add(skillStr);
            bool existsInAll = allSkills
                .any((s) => s.trim().toLowerCase() == skillStr.toLowerCase());
            if (!existsInAll) {
              allSkills.add(skillStr);
            }
          }
        }
      }
    }

    // ── Parse Specialties ──
    selectedSpecialties.clear();
    final rawSpecialties = caregiverProfile['specialties'];
    if (rawSpecialties is List) {
      for (var item in rawSpecialties) {
        if (item is Map) {
          String specId = (item['_id'] ?? item['id'] ?? '').toString().trim();
          String specName = (item['name'] ?? '').toString().trim();
          if (specId.isNotEmpty) {
            selectedSpecialties.add(specId);
          }
          if (specName.isNotEmpty) {
            selectedSpecialties.add(specName);
          }
          if (specName.isNotEmpty || specId.isNotEmpty) {
            bool exists = categories.any((cat) =>
                (specId.isNotEmpty && cat.id == specId) ||
                (specName.isNotEmpty &&
                    cat.name.toLowerCase() == specName.toLowerCase()));
            if (!exists) {
              categories.add(
                CategoryModel(
                  id: specId,
                  name: specName.isNotEmpty ? specName : 'Specialty',
                  description: '',
                ),
              );
            }
          }
        } else if (item != null) {
          String specStr = item.toString().trim();
          if (specStr.isNotEmpty) {
            selectedSpecialties.add(specStr);
            for (var cat in categories) {
              if (cat.name.toLowerCase() == specStr.toLowerCase()) {
                selectedSpecialties.add(cat.id);
              }
            }
          }
        }
      }
    }

    // ── Parse Experience ──
    selectedExperience.value = null;
    final exp = caregiverProfile['experience'];
    if (exp != null) {
      String expStr = exp.toString().trim();
      int? expNum = int.tryParse(expStr);
      if (expNum != null) {
        for (var option in experienceOptions) {
          final matches = RegExp(r'(\d+)')
              .allMatches(option)
              .map((match) => int.parse(match.group(1)!))
              .toList();
          if (matches.isNotEmpty && matches.first == expNum) {
            selectedExperience.value = option;
            break;
          }
        }
        if (selectedExperience.value == null) {
          for (var option in experienceOptions) {
            final matches = RegExp(r'(\d+)')
                .allMatches(option)
                .map((match) => int.parse(match.group(1)!))
                .toList();
            if (matches.length > 1 &&
                expNum > matches.first &&
                expNum < matches.last) {
              selectedExperience.value = option;
              break;
            }
          }
        }
      } else {
        for (var option in experienceOptions) {
          if (option.contains(expStr)) {
            selectedExperience.value = option;
            break;
          }
        }
      }
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

      final List<String> finalSpecialties = [];
      for (var cat in categories) {
        if (isSpecialtySelected(cat)) {
          if (cat.id.isNotEmpty && !cat.id.startsWith('p')) {
            if (!finalSpecialties.contains(cat.id)) {
              finalSpecialties.add(cat.id);
            }
          } else if (cat.name.isNotEmpty) {
            if (!finalSpecialties.contains(cat.name)) {
              finalSpecialties.add(cat.name);
            }
          }
        }
      }

      final List<String> finalSkills = [];
      for (var skill in allSkills) {
        if (isSkillSelected(skill)) {
          if (!finalSkills.contains(skill.trim())) {
            finalSkills.add(skill.trim());
          }
        }
      }

      final Map<String, dynamic> profileData = {
        "bio": bioController.text.trim(),
        "specialties": finalSpecialties,
        "skills": finalSkills,
        "experience": expYears,
        "hourlyRate": double.tryParse(hourlyRateController.text.trim()) ?? 0,
        "city": cityController.text.trim(),
        "state": stateController.text.trim(),
        "country": countryController.text.trim(),
      };

      final response = await CaregiverRepository.instance
          .updateProfile(profileData: profileData);

      if (response.isSuccess) {
        showCustomSnackbar(
            message: "Profile updated successfully", isError: false);
        Get.back();
      } else {
        showCustomSnackbar(message: response.message, isError: true);
      }
    } catch (e) {
      showCustomSnackbar(
          message: "Failed to update profile: $e", isError: true);
    } finally {
      isSubmitting.value = false;
      update();
    }
  }
}
