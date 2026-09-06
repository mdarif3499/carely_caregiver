import 'package:carely_caregiver/repositories/chat_repository.dart';
import 'package:carely_caregiver/repositories/client_repository.dart';
import 'package:carely_caregiver/routes/app_routes.dart';
import 'package:carely_caregiver/screens/care_giver_screens/all_schedule_screen/model/care_giver_schedule_model.dart';
import 'package:carely_caregiver/screens/chat_list_screen/controller/chat_list_controller.dart';
import 'package:carely_caregiver/services/share_pref_helper/share_pref_helper.dart';
import 'package:carely_caregiver/widgets/show_custom_snackbar.dart';
import 'package:core_kit/button/common_button.dart';
import 'package:core_kit/text/common_text.dart';
import 'package:core_kit/utils/core_screen_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constant/app_colors.dart';

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

  void showCancelDialog() {
    final TextEditingController reasonC = TextEditingController();
    final colors = AppColors.instance;

    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.r)),
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonText(
                text: 'Cancel Booking',
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                textAlign: TextAlign.start,
              ),
              12.height,
              CommonText(
                text: 'Please provide a reason for cancelling this booking request.',
                fontSize: 15.sp,
                fontWeight: FontWeight.w400,
                textColor: colors.secondaryText,
                textAlign: TextAlign.start,
                maxLines: 2,
              ),
              20.height,
              TextField(
                controller: reasonC,
                maxLines: 3,
                style: TextStyle(fontSize: 14.sp, color: colors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'e.g. Plans have changed...',
                  hintStyle: TextStyle(color: colors.textGrey.withAlpha(120)),
                  filled: true,
                  fillColor: colors.boxBg.withAlpha(30),
                  contentPadding: EdgeInsets.all(16.r),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide(color: colors.primary, width: 1.5),
                  ),
                ),
              ),
              24.height,
              Row(
                children: [
                  Expanded(
                    child: CommonButton(
                      titleText: 'Go Back',
                      buttonColor: colors.boxBg,
                      titleColor: colors.textPrimary,
                      buttonHeight: 48,
                      buttonRadius: 14,
                      onTap: () => Get.back(),
                    ),
                  ),
                  12.width,
                  Expanded(
                    child: CommonButton(
                      titleText: 'Confirm',
                      buttonColor: colors.secondaryColor,
                      titleColor: colors.white,
                      buttonHeight: 48,
                      buttonRadius: 14,
                      onTap: () {
                        final reason = reasonC.text.trim();
                        if (reason.isEmpty) {
                          showCustomSnackbar(message: "Please enter a reason", isError: true);
                          return;
                        }
                        Get.back();
                        cancelRequest(reason);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> cancelRequest(String reason) async {
    final id = booking.value?.id;
    if (id == null || id == 'placeholder') return;

    try {
      isLoading.value = true;
      update();

      final response = await ClientRepository.instance.cancelBooking(id, reason);

      if (response.isSuccess) {
        showCustomSnackbar(message: "Booking cancelled successfully.", isError: false);
        await fetchBookingDetails(id);
      } else {
        showCustomSnackbar(message: response.message, isError: true);
      }
    } catch (e) {
      debugPrint("Error cancelling booking: $e");
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

        await Get.toNamed(AppRoutes.instance.messageScreen, arguments: conversation);
        try {
           Get.find<ChatListController>().fetchConversations();
        } catch (_) {}
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
