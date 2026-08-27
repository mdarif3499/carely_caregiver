import 'package:carely_caregiver/constant/app_api_end_point.dart';

class CaregiverDocumentModel {
  final String id;
  final String caregiver;
  final String documentType;
  final String fileUrl;
  final String fileName;
  final String status;
  final String? rejectionReason;
  final DateTime? verifiedAt;
  final DateTime createdAt;

  CaregiverDocumentModel({
    required this.id,
    required this.caregiver,
    required this.documentType,
    required this.fileUrl,
    required this.fileName,
    required this.status,
    this.rejectionReason,
    this.verifiedAt,
    required this.createdAt,
  });

  factory CaregiverDocumentModel.fromJson(Map<String, dynamic> json) {
    return CaregiverDocumentModel(
      id: json['_id'] ?? '',
      caregiver: json['caregiver'] ?? '',
      documentType: json['documentType'] ?? '',
      fileUrl: AppApiEndPoint.imageUrl(json['fileUrl']),
      fileName: json['fileName'] ?? 'Document',
      status: json['status'] ?? 'PENDING',
      rejectionReason: json['rejectionReason'],
      verifiedAt: json['verifiedAt'] != null ? DateTime.tryParse(json['verifiedAt']) : null,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  String get displayType {
    return documentType.split('_').map((word) {
      if (word.isEmpty) return "";
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
}
