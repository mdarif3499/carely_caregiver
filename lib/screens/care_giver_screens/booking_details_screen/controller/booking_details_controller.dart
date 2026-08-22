import 'package:carely_caregiver/constant/app_api_end_point.dart';
import 'package:carely_caregiver/repositories/caregiver_repository.dart';
import 'package:carely_caregiver/widgets/show_custom_snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


class BookingDetails {
  final String id;
  final String clientName;
  final String avatarUrl;
  final String recipientName;
  final String relationship;
  final String serviceName;
  final String date;
  final String startTime;
  final String endTime;
  final double earnings;
  final String status;
  final String instructions;

  const BookingDetails({
    required this.id,
    required this.clientName,
    required this.avatarUrl,
    required this.recipientName,
    required this.relationship,
    required this.serviceName,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.earnings,
    required this.status,
    required this.instructions,
  });

  factory BookingDetails.fromJson(Map<String, dynamic> json) {
    final client = json['client'] ?? {};
    final recipient = json['careRecipient'] ?? {};
    final service = json['serviceCategory'] ?? {};

    return BookingDetails(
      id: json['_id'] ?? '',
      clientName: client['name'] ?? 'Unknown',
      avatarUrl: AppApiEndPoint.imageUrl(client['profileImage']),
      recipientName: recipient['fullName'] ?? 'Unknown',
      relationship: recipient['relationship'] ?? 'Family',
      serviceName: service['name'] ?? 'General Care',
      date: json['date'] ?? '',
      startTime: json['slotStartTime'] ?? '00:00',
      endTime: json['slotEndTime'] ?? '00:00',
      earnings: (json['totalAmount'] ?? 0.0).toDouble(),
      status: json['status'] ?? 'PENDING',
      instructions: json['instructions'] ?? 'No instructions provided.',
    );
  }

  String get formattedDate {
    try {
      final dt = DateTime.parse(date);
      return DateFormat('EEEE, MMM d').format(dt);
    } catch (_) {
      return date;
    }
  }

  String get timeRange => '${_formatTime(startTime)} - ${_formatTime(endTime)}';

  String _formatTime(String time) {
    try {
      final parts = time.split(':');
      final dt = DateTime(0, 1, 1, int.parse(parts[0]), int.parse(parts[1]));
      return DateFormat('hh:mm a').format(dt);
    } catch (_) {
      return time;
    }
  }
}

// ─────────────────────────────────────────────
//  Controller
// ─────────────────────────────────────────────
class BookingDetailsController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isActionLoading = false.obs;
  final Rxn<BookingDetails> booking = Rxn<BookingDetails>();

  @override
  void onInit() {
    super.onInit();
    final id = Get.arguments;
    if (id != null && id is String) {
      fetchBookingDetails(id);
    }
  }

  Future<void> fetchBookingDetails(String id) async {
    try {
      isLoading.value = true;
      update();

      final response = await CaregiverRepository.instance.getBookingDetails(id);

      if (response.isSuccess) {
        booking.value = BookingDetails.fromJson(response.data['data'] ?? {});
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

  Future<void> accept() async {
    final id = booking.value?.id;
    if (id == null) return;

    try {
      isActionLoading.value = true;
      update();

      final response = await CaregiverRepository.instance.acceptBooking(id);

      if (response.isSuccess) {
        showCustomSnackbar(message: "Booking accepted successfully!", isError: false);
        fetchBookingDetails(id); // Refresh to hide buttons
      } else {
        showCustomSnackbar(message: response.message, isError: true);
      }
    } catch (e) {
      showCustomSnackbar(message: "Failed to accept booking", isError: true);
    } finally {
      isActionLoading.value = false;
      update();
    }
  }

  Future<void> decline() async {
    final id = booking.value?.id;
    if (id == null) return;

    try {
      isActionLoading.value = true;
      update();

      final response = await CaregiverRepository.instance.declineBooking(id);

      if (response.isSuccess) {
        showCustomSnackbar(message: "Booking declined.", isError: false);
        fetchBookingDetails(id); // Refresh to hide buttons
      } else {
        showCustomSnackbar(message: response.message, isError: true);
      }
    } catch (e) {
      showCustomSnackbar(message: "Failed to decline booking", isError: true);
    } finally {
      isActionLoading.value = false;
      update();
    }
  }
}
