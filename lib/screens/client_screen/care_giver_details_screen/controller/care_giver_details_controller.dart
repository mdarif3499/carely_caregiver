import 'package:get/get.dart';

// ── Availability Model ───────────────────────────────────
class AvailabilityModel {
  final String day;
  final String date;
  final bool isAvailable;

  const AvailabilityModel({
    required this.day,
    required this.date,
    required this.isAvailable,
  });

  String get status => isAvailable ? 'Available' : 'Booked';
}

// ── Controller ───────────────────────────────────────────
class CareGiverDetailsController extends GetxController {
  // ── Specialties ──
  final RxList<String> specialties = <String>[
    'Dementia Care',
    'Post-Surgical',
    'Elderly Care',
    'Memory Care',
    'Daily Living',
  ].obs;

  // ── Upcoming Availability ──
  final RxList<AvailabilityModel> availability = <AvailabilityModel>[
    AvailabilityModel(day: 'Mon', date: '12 Sep', isAvailable: true),
    AvailabilityModel(day: 'Tue', date: '13 Sep', isAvailable: false),
    AvailabilityModel(day: 'Wed', date: '14 Sep', isAvailable: true),
    AvailabilityModel(day: 'Wed', date: '15 Sep', isAvailable: true),
    AvailabilityModel(day: 'Wed', date: '16 Sep', isAvailable: false),
  ].obs;
}
