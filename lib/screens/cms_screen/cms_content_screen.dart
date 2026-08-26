import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:carely_caregiver/screens/cms_screen/controller/cms_controller.dart';
import 'package:carely_caregiver/widgets/default_background_template.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CMSContentScreen extends StatelessWidget {
  final String title;
  final String slug;
  
  const CMSContentScreen({
    super.key, 
    required this.title, 
    required this.slug,
  });

  @override
  Widget build(BuildContext context) {
    // Unique tag for each slug so multiple instances don't share the same controller
    final c = Get.put(CMSController(slug: slug), tag: slug);
    final colors = AppColors.instance;

    return DefaultBackgroundTemplate(
      appBarTitle: title,
      child: Obx(() {
        if (c.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = c.cmsData.value;
        if (data == null) {
          return Center(
            child: CommonText(
              text: "Content not available",
              textColor: colors.secondaryText,
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Last Updated Banner ──
              _LastUpdatedBanner(date: data.updatedAt),
              const SizedBox(height: 24),

              // ── HTML Content ──
              // CommonText already handles HTML content internally
              CommonText(
                text: data.content,
                fontSize: 15,
                fontWeight: FontWeight.w400,
                textColor: colors.textPrimary,
                textAlign: TextAlign.start,
                height: 1.5,
                isDescription: true,
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      }),
    );
  }
}

class _LastUpdatedBanner extends StatelessWidget {
  final DateTime date;
  const _LastUpdatedBanner({required this.date});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    final formattedDate = DateFormat('MMMM dd, yyyy').format(date);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: colors.primary.withAlpha(10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.primary.withAlpha(20)),
      ),
      child: Row(
        children: [
          Icon(Icons.update_rounded, size: 18, color: colors.primary),
          const SizedBox(width: 10),
          CommonText(
            text: 'Last Updated: $formattedDate',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            textColor: colors.primary,
          ),
        ],
      ),
    );
  }
}
