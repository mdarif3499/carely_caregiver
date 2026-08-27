import 'package:carely_caregiver/app_all_enum/app_login_status.dart';
import 'package:carely_caregiver/repositories/caregiver_repository.dart';
import 'package:carely_caregiver/repositories/client_repository.dart';
import 'package:carely_caregiver/screens/care_giver_screens/all_schedule_screen/model/care_giver_schedule_model.dart';
import 'package:carely_caregiver/widgets/show_custom_snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../routes/app_routes.dart';

class AllScheduleController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<CareGiverScheduleModel> schedules = <CareGiverScheduleModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _setPlaceholders();
    fetchSchedules();
  }

  void _setPlaceholders() {
    schedules.value = List.generate(5, (index) => CareGiverScheduleModel(
      id: 'placeholder_$index',
      clientId: '',
      clientName: 'Client Name',
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
      amount: 0.0,
      instructions: '',
    ));
  }

  Future<void> fetchSchedules() async {
    try {
      isLoading.value = true;
      update();

      final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      debugPrint("Fetching schedules for role: $selectedAppUserType, date: $today");

      final response = selectedAppUserType == AppUserType.caregiver
          ? await CaregiverRepository.instance.getCaregiverBookings(date: today)
          : await ClientRepository.instance.getClientBookings(date: today);

      if (response.isSuccess) {
        final List dataList = response.data['data']?['data'] ?? [];
        schedules.value = dataList.map((e) => CareGiverScheduleModel.fromJson(e)).toList();
      } else {
        showCustomSnackbar(message: response.message, isError: true);
      }
    } catch (e) {
      debugPrint("Error fetching all schedules: $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }

  void onRefresh() => fetchSchedules();

  void onViewDetails(CareGiverScheduleModel item) {
    if (selectedAppUserType == AppUserType.caregiver) {
      Get.toNamed(AppRoutes.instance.bookingDetailsScreen, arguments: item.id);
    } else {
      Get.toNamed(AppRoutes.instance.clientBookingDetails, arguments: item.id);
    }
  }
}
