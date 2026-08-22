import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../repositories/client_repository.dart';

class RecipientModel {
  final String id;
  final String name;
  final String relationship;
  final List<String> tags;
  final String imageUrl;

  const RecipientModel({
    required this.id,
    required this.name,
    required this.relationship,
    required this.tags,
    this.imageUrl = '',
  });

  factory RecipientModel.fromJson(Map<String, dynamic> json) {
    return RecipientModel(
      id: json['_id'] ?? '',
      name: json['fullName'] ?? 'Unknown',
      relationship: json['relationship'] ?? 'Family',
      tags: (json['medicalConditions'] as String? ?? '').split(',').where((e) => e.isNotEmpty).toList(),
      imageUrl: '',
    );
  }
}

class CareRecipientsController extends GetxController {
  final RxList<RecipientModel> recipients = <RecipientModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRecipients();
  }

  Future<void> fetchRecipients() async {
    try {
      isLoading.value = true;
      final response = await ClientRepository.instance.getCareRecipients();
      if (response.isSuccess) {
        final List data = response.data['data'] ?? [];
        recipients.value = data.map((e) => RecipientModel.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint("Error fetching recipients: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void addRecipient() {
    // Navigate to new recipient screen
  }

  void selectRecipient(RecipientModel recipient) {
    // Handle selection
  }
}
