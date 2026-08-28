import 'package:carely_caregiver/constant/app_api_end_point.dart';
import 'package:carely_caregiver/models/category_model.dart';
import 'package:carely_caregiver/repositories/caregiver_repository.dart';
import 'package:carely_caregiver/repositories/client_repository.dart';
import 'package:carely_caregiver/widgets/bottom_shit_widget.dart';
import 'package:flutter/cupertino.dart';
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
  final String serviceCategoryId;

  const CaregiverModel({
    required this.id,
    required this.name,
    required this.role,
    required this.specialty,
    required this.description,
    required this.rating,
    required this.hourlyRate,
    required this.serviceCategoryId,
    this.avatarUrl = '',
  });

  factory CaregiverModel.fromJson(Map<String, dynamic> json) {
    final userData = json['user'] as Map<String, dynamic>? ?? {};
    final specialties = json['specialties'] as List? ?? [];
    
    return CaregiverModel(
      id: userData['_id'] ?? json['_id'] ?? '',
      name: userData['name'] ?? 'Unknown',
      role: 'Caregiver',
      specialty: specialties.isNotEmpty ? (specialties.first is Map ? (specialties.first['name'] ?? 'General Care') : specialties.join(', ')) : 'General Care',
      serviceCategoryId: specialties.isNotEmpty ? (specialties.first is Map ? (specialties.first['_id'] ?? specialties.first['id'] ?? '') : '') : '',
      description: json['bio'] ?? '',
      rating: (json['averageRating'] ?? 0.0).toDouble(),
      hourlyRate: (json['hourlyRate'] ?? 0.0).toDouble(),
      avatarUrl: AppApiEndPoint.imageUrl(userData['profileImage']),
    );
  }
}

// ── Controller ───────────
class FindCaregiverController extends GetxController {
  // ── Search ──
  late final TextEditingController searchController;
  final RxString searchQuery = ''.obs;
  void onSearchChanged(String val) => searchQuery.value = val;

  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxString selectedFilterId = 'All'.obs;
  final RxString selectedFilterName = 'All'.obs;

  void onFilterSelected(String name) {
    selectedFilterName.value = name;
    if (name == 'All') {
      selectedFilterId.value = 'All';
      searchQuery.value = '';
      searchController.clear();
      filterState.value = FilterState();
    } else {
      final category = categories.firstWhere((element) => element.name == name);
      selectedFilterId.value = category.id;
    }
    fetchCaregivers();
  }

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

  final RxList<CaregiverModel> caregivers = <CaregiverModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    searchController = TextEditingController();
    
    // Handle incoming arguments for pre-filtering
    final args = Get.arguments;
    if (args is Map) {
      if (args['categoryId'] != null) {
        selectedFilterId.value = args['categoryId'];
      }
      if (args['categoryName'] != null) {
        selectedFilterName.value = args['categoryName'];
      }
    }

    initData();

    debounce(searchQuery, (_) {
      debugPrint("Search query triggered: ${searchQuery.value}");
      fetchCaregivers();
    }, time: const Duration(milliseconds: 500));
  }

  Future<void> initData() async {
    await fetchCategories();
    await fetchCaregivers();
  }

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

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void applyCategoryFilter(String id, String name) {
    selectedFilterId.value = id;
    selectedFilterName.value = name;
    fetchCaregivers();
  }


///  BookCaregiverController



  List<String> get filterCategoryNames => ['All', ...categories.map((e) => e.name)];

  Future<void> fetchCaregivers() async {
    try {
      isLoading.value = true;
      update();

      final specialty = selectedFilterId.value == 'All' ? null : selectedFilterId.value;
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

   ///   🌐 N 📡
  ///





  List<CaregiverModel> get filteredCaregivers => caregivers;
}
