import 'package:carely_caregiver/app_all_enum/app_login_status.dart';
import 'package:carely_caregiver/repositories/caregiver_repository.dart';
import 'package:carely_caregiver/repositories/client_repository.dart';
import 'package:carely_caregiver/screens/care_giver_screens/all_schedule_screen/model/care_giver_schedule_model.dart';
import 'package:carely_caregiver/widgets/show_custom_snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AllScheduleController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<CareGiverScheduleModel> schedules = <CareGiverScheduleModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchSchedules();
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
}
