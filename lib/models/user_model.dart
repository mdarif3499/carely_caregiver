import 'package:carely_caregiver/constant/app_api_end_point.dart';
import 'package:intl/intl.dart';

class UserModel {
  final String id;
  final String name;
  final String role;
  final String email;
  final String phone;
  final String? profileImage;
  final bool intakeCompleted;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.role,
    required this.email,
    required this.phone,
    this.profileImage,
    required this.intakeCompleted,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? json['id'] ?? "",
      name: json['name'] ?? "",
      role: json['role'] ?? "",
      email: json['email'] ?? "",
      phone: json['phone'] ?? "",
      profileImage: AppApiEndPoint.imageUrl(json['profileImage']),
      intakeCompleted: json['intakeCompleted'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? "") ?? DateTime.now(),
    );
  }

  String get memberSince {
    return "Member since ${DateFormat('MMMM yyyy').format(createdAt)}";
  }
}
