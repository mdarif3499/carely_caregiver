import 'package:carely_caregiver/models/category_model.dart';
import 'package:carely_caregiver/repositories/caregiver_repository.dart';
import 'package:carely_caregiver/repositories/client_repository.dart';
import 'package:carely_caregiver/routes/app_routes.dart';
import 'package:carely_caregiver/screens/app_navigation_screen/controller/app_navigation_screen_controller.dart';
import 'package:carely_caregiver/screens/care_giver_screens/all_schedule_screen/model/care_giver_schedule_model.dart';
import 'package:carely_caregiver/screens/client_screen/find_caregiver_screen/controller/find_caregiver_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// ── Controller ──────────────────────────
class ClientHomeController extends GetxController {
  // Search
  final RxString searchQuery = ''.obs;
  void onSearchChanged(String val) => searchQuery.value = val;

  // Upcoming bookings
  final RxList<CareGiverScheduleModel> upcomingBookings = <CareGiverScheduleModel>[].obs;
  final RxBool isBookingsLoading = false.obs;

  // Service Categories
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxBool isCategoriesLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _setPlaceholders();
    fetchUpcomingBookings();
    fetchCategories();
  }

  void _setPlaceholders() {
    upcomingBookings.value = List.generate(2, (index) => CareGiverScheduleModel(
      id: 'placeholder_$index',
      clientId: '',
      clientName: 'Loading Name',
      clientAvatar: '',
      caregiverId: '',
      caregiverName: 'Caregiver Name',
      caregiverAvatar: '',
      recipientName: 'Recipient',
      relationship: 'Family',
      serviceName: 'General Care',
      date: '2026-08-27',
      shift: 'MORNING',
      startTime: '09:00',
      endTime: '11:00',
      status: 'PENDING',
      paymentStatus: 'UNPAID',
      amount: 0.0,
      instructions: '',
    ));
  }

  Future<void> fetchUpcomingBookings() async {
    try {
      isBookingsLoading.value = true;
      update();

      final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final response = await ClientRepository.instance.getClientBookings(date: today);

      if (response.isSuccess) {
        final List dataList = response.data['data']?['data'] ?? [];
        upcomingBookings.value = dataList.map((e) => CareGiverScheduleModel.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint("Error fetching upcoming bookings: $e");
    } finally {
      isBookingsLoading.value = false;
      update();
    }
  }

  Future<void> fetchCategories() async {
    try {
      isCategoriesLoading.value = true;
      update();

      final response = await CaregiverRepository.instance.getCategories();
      if (response.isSuccess) {
        final List data = response.data['data'] ?? [];
        categories.value = data.map((e) => CategoryModel.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint("Error fetching categories: $e");
    } finally {
      isCategoriesLoading.value = false;
      update();
    }
  }

  void onViewDetails(String bookingId) {
    Get.toNamed(AppRoutes.instance.clientBookingDetails, arguments: bookingId);
  }

  void onSeeAllBookings() {
    Get.toNamed(AppRoutes.instance.allScheduleScreen);
  }

  void onCategoryTap(CategoryModel category) {
    try {
      final navC = Get.find<AppNavigationScreenController>();
      final findC = Get.find<FindCaregiverController>();
      
      navC.changeIndex(1); // Switch to FindCaregiver tab
      findC.applyCategoryFilter(category.id, category.name);
    } catch (e) {
      debugPrint("Error navigating to category: $e");
    }
  }

  void onLearnMore() {
    // TODO: navigate to learn more
  }

  void onFilterTap() {
    // TODO: open filter bottom sheet
  }

  void onNotificationTap() {
    Get.toNamed(AppRoutes.instance.notificationScreen);
  }
}
