import 'package:carely_caregiver/constant/app_api_end_point.dart';
import 'package:intl/intl.dart';

class CareGiverScheduleModel {
  final String id;
  final String clientId;
  final String clientName;
  final String clientAvatar;
  final String caregiverId;
  final String caregiverName;
  final String caregiverAvatar;
  final String recipientName;
  final String relationship;
  final String serviceName;
  final String date;
  final String shift;
  final String startTime;
  final String endTime;
  final String status;
  final double amount;
  final String instructions;

  CareGiverScheduleModel({
    required this.id,
    required this.clientId,
    required this.clientName,
    required this.clientAvatar,
    required this.caregiverId,
    required this.caregiverName,
    required this.caregiverAvatar,
    required this.recipientName,
    required this.relationship,
    required this.serviceName,
    required this.date,
    required this.shift,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.amount,
    required this.instructions,
  });

  factory CareGiverScheduleModel.fromJson(Map<String, dynamic> json) {
    final client = json['client'];
    final caregiver = json['caregiver'];
    final recipient = json['careRecipient'];
    final service = json['serviceCategory'];

    return CareGiverScheduleModel(
      id: json['_id'] ?? '',
      clientId: (client is Map) ? (client['_id'] ?? client['id'] ?? '') : (client?.toString() ?? ''),
      clientName: (client is Map) ? (client['name'] ?? 'Unknown Client') : 'Unknown Client',
      clientAvatar: (client is Map) ? AppApiEndPoint.imageUrl(client['profileImage']) : "",
      caregiverId: (caregiver is Map) ? (caregiver['_id'] ?? caregiver['id'] ?? '') : (caregiver?.toString() ?? ''),
      caregiverName: (caregiver is Map) ? (caregiver['name'] ?? 'Unknown Caregiver') : 'Unknown Caregiver',
      caregiverAvatar: (caregiver is Map) ? AppApiEndPoint.imageUrl(caregiver['profileImage']) : "",
      recipientName: (recipient is Map) ? (recipient['fullName'] ?? 'Unknown Recipient') : 'Unknown Recipient',
      relationship: (recipient is Map) ? (recipient['relationship'] ?? 'Family') : 'Family',
      serviceName: (service is Map) ? (service['name'] ?? 'General Care') : 'General Care',
      date: json['date'] ?? '',
      shift: json['shift'] ?? 'MORNING',
      startTime: json['slotStartTime'] ?? '00:00',
      endTime: json['slotEndTime'] ?? '00:00',
      status: json['status'] ?? 'PENDING',
      amount: (json['totalAmount'] ?? 0.0).toDouble(),
      instructions: json['instructions'] ?? '',
    );
  }

  String get formattedTimeRange {
    return '${_formatTime(startTime)} - ${_formatTime(endTime)}';
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
