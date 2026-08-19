import 'package:carely_caregiver/constant/app_api_end_point.dart';
import 'package:carely_caregiver/repositories/client_repository.dart';
import 'package:carely_caregiver/widgets/bottom_shit_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

// ── Data Model ──────────────────────────────────────────
class CaregiverModel {
  final String id;
  final String name;
  final String role;
  final String specialty;
  final String description;
  final double rating;
  final double hourlyRate;
  final String avatarUrl;

  const CaregiverModel({
    required this.id,
    required this.name,
    required this.role,
    required this.specialty,
    required this.description,
    required this.rating,
    required this.hourlyRate,
    this.avatarUrl = '',
  });

  factory CaregiverModel.fromJson(Map<String, dynamic> json) {
    final userData = json['user'] as Map<String, dynamic>? ?? {};
    final specialties = json['specialties'] as List? ?? [];
    
    return CaregiverModel(
      id: json['_id'] ?? '',
      name: userData['name'] ?? 'Unknown',
      role: 'Caregiver', // Default as it's not in this specific API response
      specialty: specialties.isNotEmpty ? specialties.join(', ') : 'General Care',
      description: json['description'] ?? '', // Not in response, keeping as empty
      rating: (json['averageRating'] ?? 0.0).toDouble(),
      hourlyRate: (json['hourlyRate'] ?? 0.0).toDouble(), // Not in response, using 0.0
      avatarUrl: AppApiEndPoint.imageUrl(userData['profileImage']),
    );
  }
}

// ── Controller ───────────────────────────────────────────
class FindCaregiverController extends GetxController {
  // ── Search ──
  final RxString searchQuery = ''.obs;
  void onSearchChanged(String val) => searchQuery.value = val;

  // ── Filter chips ──
  final List<String> filterCategories = [
    'All',
    'RN',
    'Companion',
    'Specialized',
    'Therapist',
  ];
  final RxString selectedFilter = 'All'.obs;
  void onFilterSelected(String filter) {
    selectedFilter.value = filter;
    fetchCaregivers();
  }

  // ── Advanced filter state ──
  final Rx<FilterState> filterState = FilterState().obs;

  void onFilterTap() async {
    final context = Get.context;
    if (context == null) return;
    final result = await showFilterBottomSheet(
      context,
      initial: filterState.value,
    );
    if (result != null) {
      filterState.value = result;
      fetchCaregivers();
    }
  }

  // ── API State ──
  final RxList<CaregiverModel> caregivers = <CaregiverModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCaregivers();

    // Debounce search query to avoid excessive API calls
    debounce(searchQuery, (_) => fetchCaregivers(), time: const Duration(milliseconds: 800));
  }

  Future<void> fetchCaregivers() async {
    try {
      isLoading.value = true;
      update();

      final specialty = selectedFilter.value == 'All' ? null : selectedFilter.value;
      final skills = filterState.value.selectedSkills.isNotEmpty 
          ? filterState.value.selectedSkills.join(', ') 
          : null;
      final language = filterState.value.selectedLanguage;

      debugPrint("Fetching Caregivers: search=${searchQuery.value}, specialty=$specialty, skills=$skills, lang=$language");

      final response = await ClientRepository.instance.getCaregiverProfiles(
        searchTerm: searchQuery.value,
        specialty: specialty,
        skills: skills,
        language: language,
        // Passing null so parameters are only added if filters are active
        sortBy: null, 
        sortOrder: null,
      );

      debugPrint("Caregiver Profiles API Response: ${response.data}");

      if (response.isSuccess) {
        final List data = response.data['data'] ?? [];
        caregivers.value = data.map((json) => CaregiverModel.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint("Error fetching caregivers: $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }

  // Legacy getter kept for UI compatibility if needed, but now uses API data
  List<CaregiverModel> get filteredCaregivers => caregivers;
}
