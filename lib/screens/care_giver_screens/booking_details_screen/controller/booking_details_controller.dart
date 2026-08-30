import 'package:carely_caregiver/constant/app_api_end_point.dart';
import 'package:carely_caregiver/repositories/caregiver_repository.dart';
import 'package:carely_caregiver/widgets/show_custom_snackbar.dart';
import 'package:flutter/material.dart';
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
  final String paymentStatus;
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
    required this.paymentStatus,
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
      paymentStatus: json['paymentStatus'] ?? 'UNPAID',
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

  String get formattedStatus {
    String text = status.replaceAll('_', ' ').toLowerCase();
    if (text.isEmpty) return "";
    return text[0].toUpperCase() + text.substring(1);
  }

  String get formattedPaymentStatus {
    String text = paymentStatus.replaceAll('_', ' ').toLowerCase();
    if (text.isEmpty) return "";
    return text[0].toUpperCase() + text.substring(1);
  }

  String get timeRange => '${_formatTime(startTime)} - ${_formatTime(endTime)}';

  bool get canBeCompleted {
    try {
      // Parse scheduled date
      final dateParts = date.split('T')[0].split('-');
      final year = int.parse(dateParts[0]);
      final month = int.parse(dateParts[1]);
      final day = int.parse(dateParts[2]);

      // Parse start time (expected format HH:mm)
      final timeParts = startTime.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      final scheduledStart = DateTime(year, month, day, hour, minute);
      return DateTime.now().isAfter(scheduledStart);
    } catch (_) {
      // If parsing fails, default to allowing (or logging error)
      return true;
    }
  }

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
    _setPlaceholder();
    final id = Get.arguments;
    if (id != null && id is String) {
      fetchBookingDetails(id);
    }
  }

  void _setPlaceholder() {
    booking.value = const BookingDetails(
      id: 'placeholder',
      clientName: 'Client Name',
      avatarUrl: '',
      recipientName: 'Recipient',
      relationship: 'Family',
      serviceName: 'General Care',
      date: '2026-08-27',
      startTime: '09:00',
      endTime: '11:00',
      earnings: 0.0,
      status: 'PENDING',
      paymentStatus: 'UNPAID',
      instructions: 'Placeholder instructions for shimmering effect.',
    );
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

  void showDeclineDialog() {
    final TextEditingController reasonC = TextEditingController();

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Decline Booking',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Please provide a reason for declining this booking request.',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: reasonC,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'e.g. I have a prior family commitment...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              final reason = reasonC.text.trim();
              if (reason.isEmpty) {
                showCustomSnackbar(message: "Please enter a reason", isError: true);
                return;
              }
              Get.back();
              decline(reason);
            },
            child: const Text('Decline'),
          ),
        ],
      ),
    );
  }

  Future<void> decline(String reason) async {
    final id = booking.value?.id;
    if (id == null) return;

    try {
      isActionLoading.value = true;
      update();

      final response = await CaregiverRepository.instance.declineBooking(id, reason);

      if (response.isSuccess) {
        showCustomSnackbar(message: "Booking declined.", isError: false);
        fetchBookingDetails(id);
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

  Future<void> complete() async {
    final id = booking.value?.id;
    if (id == null) return;

    try {
      isActionLoading.value = true;
      update();

      final response = await CaregiverRepository.instance.completeBooking(id);

      if (response.isSuccess) {
        showCustomSnackbar(message: "Booking completed successfully!", isError: false);
        fetchBookingDetails(id);
      } else {
        showCustomSnackbar(message: response.message, isError: true);
      }
    } catch (e) {
      showCustomSnackbar(message: "Failed to complete booking", isError: true);
    } finally {
      isActionLoading.value = false;
      update();
    }
  }
}
