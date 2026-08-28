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
    _setPlaceholder();
    final String? bookingId = Get.arguments;
    if (bookingId != null) {
      fetchBookingDetails(bookingId);
    } else {
      showCustomSnackbar(message: "Invalid booking ID", isError: true);
    }
  }

  void _setPlaceholder() {
    booking.value = CareGiverScheduleModel(
      id: 'placeholder',
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
      paymentStatus: 'UNPAID',
      amount: 0.0,
      instructions: 'Placeholder instructions for shimmering shimmer effect.',
    );
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
        final currentUserRole = await SharePrefsHelper.getString(SharedPreferenceValue.role);
        final conversation = ChatConversation.fromJson(data, currentUserId, currentUserRole);

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
