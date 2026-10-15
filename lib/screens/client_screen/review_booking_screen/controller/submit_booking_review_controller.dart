import 'package:carely_caregiver/repositories/client_repository.dart';
import 'package:carely_caregiver/widgets/show_custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubmitBookingReviewController extends GetxController {
  final commentController = TextEditingController();
  final RxInt rating = 0.obs;
  final RxBool isSubmitting = false.obs;

  String bookingId = '';
  String caregiverId = '';
  String caregiverName = 'Caregiver';
  String caregiverAvatar = '';

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments is Map) {
      bookingId = arguments['bookingId']?.toString() ?? '';
      caregiverId = arguments['caregiverId']?.toString() ?? '';
      caregiverName = arguments['caregiverName']?.toString() ?? 'Caregiver';
      caregiverAvatar = arguments['caregiverAvatar']?.toString() ?? '';
    }
  }

  Future<void> submitReview() async {
    if (bookingId.isEmpty || caregiverId.isEmpty) {
      showCustomSnackbar(message: 'Booking review details are unavailable');
      return;
    }
    if (rating.value == 0) {
      showCustomSnackbar(message: 'Please select a rating');
      return;
    }

    final comment = commentController.text.trim();
    if (comment.isEmpty) {
      showCustomSnackbar(message: 'Please write a comment');
      return;
    }
    if (isSubmitting.value) return;

    try {
      isSubmitting.value = true;
      final response = await ClientRepository.instance.submitReview(
        caregiverId: caregiverId,
        bookingId: bookingId,
        rating: rating.value,
        comment: comment,
      );

      if (response.isSuccess) {
        showCustomSnackbar(
          message: 'Your review has been submitted successfully.',
          isError: false,
        );
        Get.back();
      } else {
        showCustomSnackbar(message: response.message);
      }
    } catch (e) {
      debugPrint('Error submitting booking review: $e');
      showCustomSnackbar(
          message: 'Could not submit your review. Please try again.');
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }
}
