import 'package:carely_caregiver/constant/app_api_end_point.dart';

class CareGiverProfileModel {
  final String id;
  final String name;
  final String profileImage;
  final double averageRating;
  final int experience;
  final List<String> skills;
  final List<String> specialties;
  final int totalReviews;
  final bool verifiedBadge;
  final String bio;
  final String city;
  final String state;
  final double hourlyRate;
  final List<AvailabilityDate> availability;

  CareGiverProfileModel({
    required this.id,
    required this.name,
    required this.profileImage,
    required this.averageRating,
    required this.experience,
    required this.skills,
    required this.specialties,
    required this.totalReviews,
    required this.verifiedBadge,
    required this.bio,
    required this.city,
    required this.state,
    required this.hourlyRate,
    required this.availability,
  });

  factory CareGiverProfileModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] ?? {};
    final specialtiesData = json['specialties'] as List? ?? [];
    final availabilityData = json['availability'] as List? ?? [];

    return CareGiverProfileModel(
      id: user['_id'] ?? json['_id'] ?? '',
      name: user['name'] ?? 'Unknown',
      profileImage: AppApiEndPoint.imageUrl(user['profileImage']),
      averageRating: (json['averageRating'] ?? 0.0).toDouble(),
      experience: json['experience'] ?? 0,
      skills: List<String>.from(json['skills'] ?? []),
      specialties: specialtiesData.map((e) => (e as Map)['name']?.toString() ?? '').toList(),
      totalReviews: json['totalReviews'] ?? 0,
      verifiedBadge: json['verifiedBadge'] ?? false,
      bio: json['bio'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      hourlyRate: (json['hourlyRate'] ?? 0.0).toDouble(),
      availability: availabilityData.map((e) => AvailabilityDate.fromJson(e)).toList(),
    );
  }

  String get location => city.isNotEmpty && state.isNotEmpty ? "$city, $state" : city.isNotEmpty ? city : state;
}

class AvailabilityDate {
  final String id;
  final DateTime date;
  final List<ShiftData> shifts;

  AvailabilityDate({
    required this.id,
    required this.date,
    required this.shifts,
  });

  factory AvailabilityDate.fromJson(Map<String, dynamic> json) {
    final shiftsData = json['shifts'] as List? ?? [];
    return AvailabilityDate(
      id: json['_id'] ?? '',
      date: DateTime.parse(json['date']),
      shifts: shiftsData.map((e) => ShiftData.fromJson(e)).toList(),
    );
  }
}

class ShiftData {
  final String shiftType;
  final String startTime;
  final String endTime;
  final bool isAvailable;
  final List<SlotData> slots;

  ShiftData({
    required this.shiftType,
    required this.startTime,
    required this.endTime,
    required this.isAvailable,
    required this.slots,
  });

  factory ShiftData.fromJson(Map<String, dynamic> json) {
    final slotsData = json['slots'] as List? ?? [];
    return ShiftData(
      shiftType: json['shiftType'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      isAvailable: json['isAvailable'] ?? false,
      slots: slotsData.map((e) => SlotData.fromJson(e)).toList(),
    );
  }
}

class SlotData {
  final String startTime;
  final String status;

  SlotData({
    required this.startTime,
    required this.status,
  });

  factory SlotData.fromJson(Map<String, dynamic> json) {
    return SlotData(
      startTime: json['startTime'] ?? '',
      status: json['status'] ?? '',
    );
  }
}
