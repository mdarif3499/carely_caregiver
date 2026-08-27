import 'package:carely_caregiver/repositories/client_repository.dart';
import 'package:carely_caregiver/screens/client_screen/care_giver_details_screen/model/care_giver_profile_model.dart';
import 'package:carely_caregiver/widgets/show_custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// ── Availability Model ───────────────────────────────────
class AvailabilityModel {
  final DateTime date;
  final bool isAvailable;

  const AvailabilityModel({
    required this.date,
    required this.isAvailable,
  });

  String get day => DateFormat('EEE').format(date);
  String get dateLabel => DateFormat('MMM d').format(date);
  String get status => isAvailable ? 'Available' : 'Unavailable';
}

// ── Controller ───────────────────────────────────────────
class CareGiverDetailsController extends GetxController {
  final RxBool isLoading = false.obs;
  final Rxn<CareGiverProfileModel> caregiverProfile = Rxn<CareGiverProfileModel>();
  final RxList<AvailabilityModel> weekAvailability = <AvailabilityModel>[].obs;
  final Rxn<DateTime> selectedDate = Rxn<DateTime>();

  @override
  void onInit() {
    super.onInit();
    _setPlaceholder();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final String? caregiverId = Get.arguments;
      if (caregiverId != null) {
        fetchCaregiverProfile(caregiverId);
      } else {
        showCustomSnackbar(message: "Invalid caregiver ID", isError: true);
      }
    });
  }

  void _setPlaceholder() {
    caregiverProfile.value = CareGiverProfileModel(
      id: 'placeholder',
      name: 'Caregiver Name',
      profileImage: '',
      averageRating: 0.0,
      experience: 0,
      skills: ['Skill 1', 'Skill 2'],
      specialties: ['Specialty 1'],
      totalReviews: 0,
      verifiedBadge: true,
      bio: 'This is a placeholder bio for skeletonizer shimmer effect.',
      city: 'City',
      state: 'State',
      hourlyRate: 0.0,
      availability: [],
    );
    _generateWeekAvailability();
  }

  Future<void> fetchCaregiverProfile(String id) async {
    try {
      isLoading.value = true;

      final response = await ClientRepository.instance.getCaregiverProfile(id);

      if (response.isSuccess) {
        caregiverProfile.value = CareGiverProfileModel.fromJson(response.data['data'] ?? {});
        _generateWeekAvailability();
      } else {
        showCustomSnackbar(message: response.message, isError: true);
      }
    } catch (e) {
      debugPrint("Error fetching caregiver profile: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void _generateWeekAvailability() {
    if (caregiverProfile.value == null) return;

    final List<AvailabilityModel> availability = [];
    final today = DateTime.now();

    for (int i = 0; i < 7; i++) {
      final date = today.add(Duration(days: i));
      final bool isAvailable = caregiverProfile.value!.availability.any((a) {
        return a.date.year == date.year &&
               a.date.month == date.month &&
               a.date.day == date.day;
      });

      availability.add(AvailabilityModel(
        date: date,
        isAvailable: isAvailable,
      ));
    }
    weekAvailability.value = availability;
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;
  }

  String get bioDisplay {
    final bio = caregiverProfile.value?.bio ?? "";
    // Clean up system-log like text or show professional placeholder
    if (bio.isEmpty || 
        bio.contains("onRequestShow") || 
        bio.contains("ORIGIN_CLIENT") || 
        bio.contains("SHOW_SOFT_INPUT")) {
      return "Professional caregiver dedicated to providing high-quality, personalized support for your loved ones. Specialized in ensuring comfort, safety, and maintaining independence at home.";
    }
    return bio;
  }
}
