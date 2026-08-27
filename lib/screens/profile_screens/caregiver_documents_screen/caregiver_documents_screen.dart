import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:carely_caregiver/models/caregiver_document_model.dart';
import 'package:carely_caregiver/screens/profile_screens/caregiver_documents_screen/controller/caregiver_documents_controller.dart';
import 'package:carely_caregiver/widgets/default_background_template.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CaregiverDocumentsScreen extends StatelessWidget {
  const CaregiverDocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(CaregiverDocumentsController());
    final colors = AppColors.instance;

    return DefaultBackgroundTemplate(
      appBarTitle: 'Documents & Verification',
      child: Stack(
        children: [
          Obx(() {
            if (c.isLoading.value && c.documents.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (c.documents.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.description_outlined, size: 64, color: colors.border),
                    const SizedBox(height: 16),
                    CommonText(
                      text: "No documents uploaded yet",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      textColor: colors.secondaryText,
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: c.fetchMyDocuments,
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: c.documents.length,
                itemBuilder: (context, index) {
                  return _DocumentCard(doc: c.documents[index]);
                },
              ),
            );
          }),
          
          // Floating Upload Button
          Positioned(
            bottom: 24,
            right: 20,
            child: FloatingActionButton.extended(
              onPressed: () => _showUploadBottomSheet(context, c),
              backgroundColor: colors.primary,
              icon: const Icon(Icons.add_rounded, color: Colors.white),
              label: const CommonText(text: "Upload", textColor: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  void _showUploadBottomSheet(BuildContext context, CaregiverDocumentsController c) {
    final colors = AppColors.instance;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CommonText(
              text: 'Upload Document',
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
            const SizedBox(height: 8),
            CommonText(
              text: 'Select the document type and upload a clear photo or PDF.',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              textColor: colors.secondaryText,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 24),

            // Document Type Dropdown
            const CommonText(text: 'Document Type', fontSize: 14, fontWeight: FontWeight.w600),
            const SizedBox(height: 10),
            Obx(() => Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: colors.boxBg.withAlpha(50),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colors.border),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: c.selectedDocType.value,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  items: c.documentTypes.map((type) {
                    return DropdownMenuItem(
                      value: type['value'],
                      child: CommonText(text: type['label']!, textAlign: TextAlign.start),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) c.selectedDocType.value = val;
                  },
                ),
              ),
            )),
            const SizedBox(height: 20),

            // File Picker Area
            GestureDetector(
              onTap: c.pickDocument,
              child: Obx(() => Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 30),
                decoration: BoxDecoration(
                  color: colors.primary.withAlpha(5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colors.primary.withAlpha(30), style: BorderStyle.solid),
                ),
                child: Column(
                  children: [
                    Icon(
                      c.selectedFile.value != null ? Icons.check_circle_rounded : Icons.cloud_upload_outlined,
                      size: 48,
                      color: c.selectedFile.value != null ? Colors.green : colors.primary,
                    ),
                    const SizedBox(height: 12),
                    CommonText(
                      text: c.selectedFile.value != null 
                          ? c.selectedFile.value!.path.split('/').last 
                          : 'Tap to select document',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      textColor: colors.textPrimary,
                    ),
                    const SizedBox(height: 4),
                    CommonText(
                      text: 'Supported: JPG, PNG, PDF (Max 5MB)',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      textColor: colors.textGrey,
                    ),
                  ],
                ),
              )),
            ),
            const SizedBox(height: 32),

            // Submit Button
            Obx(() => CommonButton(
              titleText: 'Submit for Verification',
              onTap: c.isUploading.value ? null : c.uploadDocument,
              isLoading: c.isUploading.value,
              buttonWidth: double.infinity,
              buttonHeight: 56,
              buttonRadius: 16,
            )),
            const SizedBox(height: 10),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}

class _DocumentCard extends StatelessWidget {
  final CaregiverDocumentModel doc;
  const _DocumentCard({required this.doc});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    final statusColor = _getStatusColor(doc.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colors.primary.withAlpha(10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.article_outlined, color: colors.primary, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      text: doc.displayType,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      textColor: colors.textPrimary,
                    ),
                    CommonText(
                      text: doc.fileName,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      textColor: colors.secondaryText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              _StatusBadge(status: doc.status, color: statusColor),
            ],
          ),
          const SizedBox(height: 16),
          Divider(height: 1, color: colors.boxBg),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonText(
                text: "Uploaded on ${DateFormat('MMM dd, yyyy').format(doc.createdAt)}",
                fontSize: 12,
                fontWeight: FontWeight.w500,
                textColor: colors.textGrey,
              ),
              TextButton(
                onPressed: () {
                  // Link to FullScreenImageScreen if it's an image
                  Get.toNamed('/fullScreenImage', arguments: doc.fileUrl);
                },
                child: CommonText(
                  text: "View Document",
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  textColor: colors.primary,
                ),
              ),
            ],
          ),
          if (doc.status == 'REJECTED' && doc.rejectionReason != null) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withAlpha(5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.withAlpha(10)),
              ),
              child: CommonText(
                text: "Reason: ${doc.rejectionReason}",
                fontSize: 12,
                fontWeight: FontWeight.w400,
                textColor: Colors.red,
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'VERIFIED': return Colors.green;
      case 'PENDING': return Colors.orange;
      case 'REJECTED': return Colors.red;
      default: return Colors.grey;
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  final Color color;
  const _StatusBadge({required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(50),
      ),
      child: CommonText(
        text: status,
        fontSize: 10,
        fontWeight: FontWeight.w800,
        textColor: color,
      ),
    );
  }
}
