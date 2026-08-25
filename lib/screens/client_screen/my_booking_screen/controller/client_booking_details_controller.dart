import 'package:carely_caregiver/constant/app_api_end_point.dart';
import 'package:carely_caregiver/repositories/chat_repository.dart';
import 'package:carely_caregiver/repositories/client_repository.dart';
import 'package:carely_caregiver/routes/app_routes.dart';
import 'package:carely_caregiver/screens/care_giver_screens/all_schedule_screen/model/care_giver_schedule_model.dart';
import 'package:carely_caregiver/screens/chat_list_screen/controller/chat_list_controller.dart';
import 'package:carely_caregiver/services/share_pref_helper/share_pref_helper.dart';
import 'package:carely_caregiver/widgets/show_custom_snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class ClientBookingDetailsController extends GetxController {
  final RxBool isLoading = false.obs;
  final Rxn<CareGiverScheduleModel> booking = Rxn<CareGiverScheduleModel>();

  @override
  void onInit() {
    super.onInit();
    final String? bookingId = Get.arguments;
    if (bookingId != null) {
      fetchBookingDetails(bookingId);
    } else {
      showCustomSnackbar(message: "Invalid booking ID", isError: true);
    }
  }

  Future<void> fetchBookingDetails(String id) async {
    try {
      isLoading.value = true;
      update();

      final response = await ClientRepository.instance.getBookingDetails(id);

      if (response.isSuccess) {
        booking.value = CareGiverScheduleModel.fromJson(response.data['data'] ?? {});
      } else {
        showCustomSnackbar(message: response.message, isError: true);
      }
    } catch (e) {
      debugPrint("Error fetching booking details: $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> onChat() async {
    final b = booking.value;
    if (b == null) return;

    try {
      isLoading.value = true;
      update();

      // The receiverId should be the caregiver's user ID
      final response = await ChatRepository.instance.getOrCreateConversation(b.caregiverId);

      if (response.isSuccess) {
        final data = response.data['data'] ?? {};
        final currentUserId = await SharePrefsHelper.getString(SharedPreferenceValue.userId);
        final conversation = ChatConversation.fromJson(data, currentUserId);

        Get.toNamed(AppRoutes.instance.messageScreen, arguments: conversation);
      } else {
        showCustomSnackbar(message: response.message, isError: true);
      }
    } catch (e) {
      debugPrint("Error creating conversation: $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }
}
