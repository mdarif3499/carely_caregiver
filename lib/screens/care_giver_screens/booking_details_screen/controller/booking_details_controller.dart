import 'package:get/get.dart';

// ─────────────────────────────────────────────
//  Model
// ─────────────────────────────────────────────
class BookingDetails {
  final String id;
  final String clientName;
  final String avatarUrl;
  final int clientAge;
  final String careType;
  final double rating;
  final int reviewCount;
  final String date;
  final String timeRange;
  final String duration;
  final double earnings;
  final String serviceType;
  final String serviceId;
  final String additionalInstructions;

  const BookingDetails({
    required this.id,
    required this.clientName,
    required this.avatarUrl,
    required this.clientAge,
    required this.careType,
    required this.rating,
    required this.reviewCount,
    required this.date,
    required this.timeRange,
    required this.duration,
    required this.earnings,
    required this.serviceType,
    required this.serviceId,
    required this.additionalInstructions,
  });
}

// ─────────────────────────────────────────────
//  Controller
// ─────────────────────────────────────────────
class BookingDetailsController extends GetxController {
  final RxBool isLoading = false.obs;

  final booking = const BookingDetails(
    id: 'BK-89021',
    clientName: 'Sarah Jenkins',
    avatarUrl: '',
    clientAge: 82,
    careType: 'Post-op Care',
    rating: 4.9,
    reviewCount: 12,
    date: 'Today, Oct 24',
    timeRange: '10:00 AM - 2:00 PM',
    duration: '4 hrs',
    earnings: 120.00,
    serviceType: 'Specialized Dementia Care',
    serviceId: '#BK-89021',
    additionalInstructions:
        'Client enjoys morning tea in the garden. Please monitor fluid intake. '
        'Goldie (Golden Retriever) is friendly but should not be fed human food.',
  );

  void accept() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 600));

    isLoading.value = false;
    Get.back();

  }

  void decline() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 600));
    isLoading.value = false;
    Get.back();

  }
}
