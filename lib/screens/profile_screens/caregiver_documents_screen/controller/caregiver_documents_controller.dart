import 'dart:io';
import 'package:carely_caregiver/models/caregiver_document_model.dart';
import 'package:carely_caregiver/repositories/caregiver_repository.dart';
import 'package:carely_caregiver/widgets/show_custom_snackbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class CaregiverDocumentsController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isUploading = false.obs;
  final RxList<CaregiverDocumentModel> documents = <CaregiverDocumentModel>[].obs;

  // Upload States
  final RxString selectedDocType = 'NURSING_CERT'.obs;
  final Rxn<File> selectedFile = Rxn<File>();

  final List<Map<String, String>> documentTypes = [
    {"label": "Nursing Certificate", "value": "NURSING_CERT"},
    {"label": "Government ID", "value": "GOVERNMENT_ID"},
    {"label": "Criminal Record", "value": "CRIMINAL_RECORD"},
    {"label": "Insurance", "value": "INSURANCE"},
  ];

  @override
  void onInit() {
    super.onInit();
    fetchMyDocuments();
  }

  Future<void> fetchMyDocuments() async {
    try {
      isLoading.value = true;
      update();

      final response = await CaregiverRepository.instance.getMyDocuments();

      if (response.isSuccess) {
        final List dataList = response.data['data'] ?? [];
        documents.value = dataList.map((e) => CaregiverDocumentModel.fromJson(e)).toList();
      } else {
        showCustomSnackbar(message: response.message, isError: true);
      }
    } catch (e) {
      debugPrint("Error fetching caregiver documents: $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> pickDocument() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'pdf', 'png', 'jpeg'],
      );

      if (result != null && result.files.single.path != null) {
        selectedFile.value = File(result.files.single.path!);
      }
    } catch (e) {
      debugPrint("Error picking document: $e");
    }
  }

  Future<void> uploadDocument() async {
    if (selectedFile.value == null) {
      showCustomSnackbar(message: "Please select a document first", isError: true);
      return;
    }

    try {
      isUploading.value = true;
      update();

      final response = await CaregiverRepository.instance.uploadDocument(
        documentType: selectedDocType.value,
        file: selectedFile.value!,
      );

      if (response.isSuccess) {
        showCustomSnackbar(message: "Document uploaded successfully", isError: false);
        Get.back(); // Close bottom sheet
        selectedFile.value = null;
        fetchMyDocuments(); // Refresh list
      } else {
        showCustomSnackbar(message: response.message, isError: true);
      }
    } catch (e) {
      debugPrint("Error uploading document: $e");
      showCustomSnackbar(message: "Failed to upload document", isError: true);
    } finally {
      isUploading.value = false;
      update();
    }
  }
}
