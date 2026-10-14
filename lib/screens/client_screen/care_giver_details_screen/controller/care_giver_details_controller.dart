import 'package:carely_caregiver/repositories/client_repository.dart';
import 'package:carely_caregiver/constant/app_api_end_point.dart';
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

class CaregiverReview {
  final String id;
  final String clientName;
  final String clientImage;
  final int rating;
  final String comment;
  final DateTime? createdAt;

  const CaregiverReview({
    required this.id,
    required this.clientName,
    required this.clientImage,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory CaregiverReview.fromJson(Map<String, dynamic> json) {
    final client = json['client'] is Map
        ? Map<String, dynamic>.from(json['client'] as Map)
        : <String, dynamic>{};
    final rawRating = json['rating'];

    return CaregiverReview(
      id: json['_id']?.toString() ?? '',
      clientName: client['name']?.toString() ?? 'Client',
      clientImage: AppApiEndPoint.imageUrl(client['profileImage']?.toString()),
      rating: rawRating is num
          ? rawRating.round()
          : int.tryParse(rawRating?.toString() ?? '') ?? 0,
      comment: json['comment']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
    );
  }
}

// ── Controller ───────────────────────────────────────────
class CareGiverDetailsController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isReviewsLoading = false.obs;
  final Rxn<CareGiverProfileModel> caregiverProfile =
      Rxn<CareGiverProfileModel>();
  final RxList<CaregiverReview> caregiverReviews = <CaregiverReview>[].obs;
  final RxInt totalCaregiverReviews = 0.obs;
  final RxBool hasMoreCaregiverReviews = true.obs;
  final RxString caregiverReviewsError = ''.obs;
  static const int caregiverReviewsPageSize = 10;
  int _caregiverReviewsPage = 0;
  String _reviewsCaregiverId = '';
  final RxList<AvailabilityModel> weekAvailability = <AvailabilityModel>[].obs;
  final Rxn<DateTime> selectedDate = Rxn<DateTime>();
  String caregiverId = '';

  @override
  void onInit() {
    super.onInit();
    _setPlaceholder();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final argument = Get.arguments;
      caregiverId = argument is Map
          ? argument['caregiverId']?.toString() ?? ''
          : argument is String
              ? argument
              : '';
      if (caregiverId.isNotEmpty) {
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
      serviceCategoryId: 'placeholder',
      availability: [],
    );
    _generateWeekAvailability();
  }

  Future<void> fetchCaregiverProfile(String id) async {
    try {
      isLoading.value = true;

      final response = await ClientRepository.instance.getCaregiverProfile(id);

      if (response.isSuccess) {
        caregiverProfile.value =
            CareGiverProfileModel.fromJson(response.data['data'] ?? {});
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

  Future<void> loadMoreCaregiverReviews() async {
    if (caregiverId.isEmpty ||
        isReviewsLoading.value ||
        !hasMoreCaregiverReviews.value) {
      return;
    }

    final requestedPage = _caregiverReviewsPage + 1;
    try {
      isReviewsLoading.value = true;
      caregiverReviewsError.value = '';
      final response = await ClientRepository.instance.getCaregiverReviews(
        caregiverId,
        page: requestedPage,
        limit: caregiverReviewsPageSize,
      );
      if (response.isSuccess) {
        final payload = response.data['data'];
        final reviewList =
            payload is Map ? payload['data'] as List? ?? [] : <dynamic>[];
        final meta = payload is Map && payload['meta'] is Map
            ? Map<String, dynamic>.from(payload['meta'] as Map)
            : <String, dynamic>{};
        final fetchedReviews = reviewList
            .whereType<Map>()
            .map((item) => CaregiverReview.fromJson(
                  Map<String, dynamic>.from(item),
                ))
            .toList();

        final existingIds = caregiverReviews.map((review) => review.id).toSet();
        caregiverReviews.addAll(fetchedReviews.where(
          (review) => review.id.isEmpty || !existingIds.contains(review.id),
        ));
        _caregiverReviewsPage = requestedPage;

        final totalPages = int.tryParse(meta['totalPages']?.toString() ?? '');
        final total = int.tryParse(meta['total']?.toString() ?? '');
        if (total != null) totalCaregiverReviews.value = total;
        hasMoreCaregiverReviews.value = totalPages != null
            ? requestedPage < totalPages
            : fetchedReviews.length >= caregiverReviewsPageSize;
      } else {
        caregiverReviewsError.value = response.message;
        showCustomSnackbar(message: response.message, isError: true);
      }
    } catch (e) {
      debugPrint("Error fetching caregiver reviews: $e");
      caregiverReviewsError.value = "Couldn't load reviews. Tap to try again.";
      showCustomSnackbar(
          message: "Could not load reviews. Please try again.", isError: true);
    } finally {
      isReviewsLoading.value = false;
    }
  }

  Future<void> prepareCaregiverReviews(String id) async {
    if (id.isEmpty) {
      showCustomSnackbar(message: "Invalid caregiver ID", isError: true);
      return;
    }
    caregiverId = id;
    if (_reviewsCaregiverId == id) return;

    _reviewsCaregiverId = id;
    caregiverReviews.clear();
    totalCaregiverReviews.value = 0;
    _caregiverReviewsPage = 0;
    hasMoreCaregiverReviews.value = true;
    await loadMoreCaregiverReviews();
  }

  Future<void> refreshCaregiverReviews() async {
    if (isReviewsLoading.value) return;
    _reviewsCaregiverId = '';
    caregiverReviews.clear();
    totalCaregiverReviews.value = 0;
    _caregiverReviewsPage = 0;
    hasMoreCaregiverReviews.value = true;
    await prepareCaregiverReviews(caregiverId);
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

    // Auto-select the first available date
    if (selectedDate.value == null) {
      final firstAvailable =
          availability.firstWhereOrNull((a) => a.isAvailable);
      if (firstAvailable != null) {
        selectedDate.value = firstAvailable.date;
      }
    }
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;
  }

  Future<void> onRefresh() async {
    if (caregiverId.isNotEmpty) {
      await fetchCaregiverProfile(caregiverId);
    }
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
