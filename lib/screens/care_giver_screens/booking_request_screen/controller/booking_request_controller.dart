import 'package:get/get.dart';

// ─────────────────────────────────────────────
//  Model
// ─────────────────────────────────────────────
class BookingRequest {
  final String id;
  final String clientName;
  final String clientRole;
  final String avatarUrl;
  final double rating;
  final int previousJobs;
  final String serviceType;
  final String dateTime;
  final String duration;
  final String location;
  final double distanceMiles;

  const BookingRequest({
    required this.id,
    required this.clientName,
    required this.clientRole,
    required this.avatarUrl,
    required this.rating,
    required this.previousJobs,
    required this.serviceType,
    required this.dateTime,
    required this.duration,
    required this.location,
    required this.distanceMiles,
  });
}

// ─────────────────────────────────────────────
//  Controller
// ─────────────────────────────────────────────
class BookingRequestController extends GetxController {
  final RxInt selectedTab = 0.obs; // 0 = New, 1 = History

  final List<BookingRequest> newRequests = const [
    BookingRequest(
      id: '1',
      clientName: 'Sarah Jenkins',
      clientRole: 'RN',
      avatarUrl: '',
      rating: 4.9,
      previousJobs: 12,
      serviceType: 'Elderly Care - Post-Op Support',
      dateTime: 'Monday, Oct 12 . 09:00 AM - 02:00 PM',
      duration: '5h',
      location: 'West Village',
      distanceMiles: 1.2,
    ),
    BookingRequest(
      id: '2',
      clientName: 'Mark Thompson',
      clientRole: 'LPN',
      avatarUrl: '',
      rating: 4.7,
      previousJobs: 8,
      serviceType: 'Dementia Care - Daily Routine',
      dateTime: 'Tuesday, Oct 13 . 10:00 AM - 03:00 PM',
      duration: '5h',
      location: 'Brooklyn Heights',
      distanceMiles: 2.4,
    ),
    BookingRequest(
      id: '3',
      clientName: 'Linda Moore',
      clientRole: 'CNA',
      avatarUrl: '',
      rating: 4.8,
      previousJobs: 15,
      serviceType: 'Post-Surgery Recovery Support',
      dateTime: 'Wednesday, Oct 14 . 08:00 AM - 01:00 PM',
      duration: '5h',
      location: 'Upper East Side',
      distanceMiles: 0.9,
    ),
  ];

  final List<BookingRequest> historyRequests = const [
    BookingRequest(
      id: '4',
      clientName: 'James Wilson',
      clientRole: 'RN',
      avatarUrl: '',
      rating: 4.6,
      previousJobs: 5,
      serviceType: 'Medication Management',
      dateTime: 'Friday, Oct 10 . 07:00 AM - 12:00 PM',
      duration: '5h',
      location: 'Chelsea',
      distanceMiles: 3.1,
    ),
    BookingRequest(
      id: '5',
      clientName: 'Anna Roberts',
      clientRole: 'LPN',
      avatarUrl: '',
      rating: 4.5,
      previousJobs: 3,
      serviceType: 'Companion Care',
      dateTime: 'Thursday, Oct 9 . 11:00 AM - 04:00 PM',
      duration: '5h',
      location: 'Midtown',
      distanceMiles: 1.7,
    ),
  ];

  List<BookingRequest> get activeList =>
      selectedTab.value == 0 ? newRequests : historyRequests;

  void selectTab(int index) => selectedTab.value = index;

  void acceptRequest(String id) {
    Get.snackbar('Accepted', 'Booking #$id accepted!');
  }

  void declineRequest(String id) {
    Get.snackbar('Declined', 'Booking #$id declined.');
  }
}
