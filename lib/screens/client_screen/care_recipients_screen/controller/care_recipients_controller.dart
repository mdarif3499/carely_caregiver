import 'package:get/get.dart';

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
}

class CareRecipientsController extends GetxController {
  final RxList<RecipientModel> recipients = <RecipientModel>[
    const RecipientModel(
      id: '1',
      name: 'Sarah Henderson',
      relationship: 'Mother',
      tags: ['ELDERLY CARE', 'MOBILITY ASSISTANCE'],
    ),
    const RecipientModel(
      id: '2',
      name: 'James Henderson',
      relationship: 'Father',
      tags: ['ELDERLY CARE', 'DEMENTIA CARE'],
    ),
  ].obs;

  void addRecipient() {
    // Navigate to new recipient screen
  }

  void selectRecipient(RecipientModel recipient) {
    // Handle selection
  }
}
