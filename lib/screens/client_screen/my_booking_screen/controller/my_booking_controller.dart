import 'package:carely_caregiver/repositories/client_repository.dart';
import 'package:carely_caregiver/screens/care_giver_screens/all_schedule_screen/model/care_giver_schedule_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class MyBookingController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<CareGiverScheduleModel> bookings = <CareGiverScheduleModel>[].obs;
  
  final RxString selectedStatus = 'ALL'.obs;

  final List<String> statuses = [
    'ALL',
    'PENDING',
    'CONFIRMED',
    'DECLINED',
    'CANCELLED',
    'COMPLETED',
    'AUTO_RELEASED'
  ];

  @override
  void onInit() {
    super.onInit();
    fetchMyBookings();
  }

  Future<void> fetchMyBookings() async {
    try {
      isLoading.value = true;
      update();

      final String? statusParam = selectedStatus.value == 'ALL' ? null : selectedStatus.value;
      
      final response = await ClientRepository.instance.getClientBookings(
        status: statusParam,
      );

      if (response.isSuccess) {
        final List dataList = response.data['data']?['data'] ?? [];
        bookings.value = dataList.map((e) => CareGiverScheduleModel.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint("Error fetching my bookings: $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }

  void onStatusSelected(String status) {
    selectedStatus.value = status;
    fetchMyBookings();
  }

  String formatStatus(String status) {
    if (status == 'ALL') return 'All';
    return status.split('_').map((word) {
      if (word.isEmpty) return "";
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
}
