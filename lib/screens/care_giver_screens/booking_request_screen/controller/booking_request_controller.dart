import 'package:carely_caregiver/constant/app_api_end_point.dart';
import 'package:carely_caregiver/repositories/caregiver_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../widgets/show_custom_snackbar.dart';

// ─────────────────────────────────────────────
//  Model
// ─────────────────────────────────────────────
class BookingRequest {
  final String id;
  final String clientName;
  final String clientAvatar;
  final String recipientName;
  final String relationship;
  final String serviceName;
  final String date;
  final String shift;
  final String startTime;
  final String endTime;
  final double totalAmount;
  final String status;
  final String instructions;

  const BookingRequest({
    required this.id,
    required this.clientName,
    required this.clientAvatar,
    required this.recipientName,
    required this.relationship,
    required this.serviceName,
    required this.date,
    required this.shift,
    required this.startTime,
    required this.endTime,
    required this.totalAmount,
    required this.status,
    this.instructions = '',
  });

  factory BookingRequest.fromJson(Map<String, dynamic> json) {
    final client = json['client'] ?? {};
    final recipient = json['careRecipient'] ?? {};
    final service = json['serviceCategory'] ?? {};

    return BookingRequest(
      id: json['_id'] ?? '',
      clientName: client['name'] ?? 'Unknown Client',
      clientAvatar: AppApiEndPoint.imageUrl(client['profileImage']),
      recipientName: recipient['fullName'] ?? 'Unknown Recipient',
      relationship: recipient['relationship'] ?? 'Family',
      serviceName: service['name'] ?? 'General Care',
      date: json['date'] ?? '',
      shift: json['shift'] ?? 'MORNING',
      startTime: json['slotStartTime'] ?? '00:00',
      endTime: json['slotEndTime'] ?? '00:00',
      totalAmount: (json['totalAmount'] ?? 0.0).toDouble(),
      status: json['status'] ?? 'PENDING',
      instructions: json['instructions'] ?? '',
    );
  }

  String get formattedDateTime {
    try {
      final dt = DateTime.parse(date);
      final dateStr = DateFormat('MMM d').format(dt);
      return '$dateStr, ${_formatTime(startTime)} - ${_formatTime(endTime)}';
    } catch (_) {
      return '$date, $startTime - $endTime';
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
class BookingRequestController extends GetxController {
  final RxInt selectedTab = 0.obs; // 0 = New, 1 = History
  final RxBool isLoading = false.obs;

  final RxList<BookingRequest> newRequests = <BookingRequest>[].obs;
  final RxList<BookingRequest> historyRequests = <BookingRequest>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCaregiverBookings();
  }

  Future<void> fetchCaregiverBookings() async {
    try {
      isLoading.value = true;
      update();

      debugPrint("Fetching Caregiver Bookings...");
      final response = await CaregiverRepository.instance.getCaregiverBookings();

      debugPrint("Caregiver Booking API Response Body: ${response.data}");

      if (response.isSuccess) {
        final List dataList = response.data['data']?['data'] ?? [];
        final List<BookingRequest> all = dataList.map((e) => BookingRequest.fromJson(e)).toList();

        newRequests.value = all.where((e) => e.status == 'PENDING').toList();
        historyRequests.value = all.where((e) => e.status != 'PENDING').toList();
      }
    } catch (e) {
      debugPrint("Error fetching caregiver bookings: $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }

  List<BookingRequest> get activeList =>
      selectedTab.value == 0 ? newRequests : historyRequests;

  void selectTab(int index) => selectedTab.value = index;

  Future<void> acceptRequest(String id) async {
    try {
      isLoading.value = true;
      update();

      final response = await CaregiverRepository.instance.acceptBooking(id);

      if (response.isSuccess) {
        showCustomSnackbar(message: "Booking request accepted!", isError: false);
        await fetchCaregiverBookings();
      } else {
        showCustomSnackbar(message: response.message, isError: true);
      }
    } catch (e) {
      showCustomSnackbar(message: "Failed to accept booking", isError: true);
    } finally {
      isLoading.value = false;
      update();
    }
  }

  void showDeclineDialog(String id) {
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
              declineRequest(id, reason);
            },
            child: const Text('Decline'),
          ),
        ],
      ),
    );
  }

  Future<void> declineRequest(String id, String reason) async {
    try {
      isLoading.value = true;
      update();

      final response = await CaregiverRepository.instance.declineBooking(id, reason);

      if (response.isSuccess) {
        showCustomSnackbar(message: "Booking request declined.", isError: false);
        await fetchCaregiverBookings();
      } else {
        showCustomSnackbar(message: response.message, isError: true);
      }
    } catch (e) {
      showCustomSnackbar(message: "Failed to decline booking", isError: true);
    } finally {
      isLoading.value = false;
      update();
    }
  }
}
