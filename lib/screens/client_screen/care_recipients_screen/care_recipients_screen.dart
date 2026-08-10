import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:carely_caregiver/routes/app_routes.dart';
import 'package:carely_caregiver/screens/client_screen/care_recipients_screen/controller/care_recipients_controller.dart';
import 'package:carely_caregiver/screens/client_screen/care_recipients_screen/widgets/care_recipients_widgets.dart';
import 'package:carely_caregiver/widgets/default_background_template.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CareRecipientsScreen extends StatelessWidget {
  const CareRecipientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CareRecipientsController>();
    final colors = AppColors.instance;

    return DefaultBackgroundTemplate(
      appBarTitle: 'Care Recipients',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            AddRecipientDashedCard(
              onTap: () => Get.toNamed(AppRoutes.instance.newRecipientProfileScreen),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: controller.recipients.length,
                  itemBuilder: (context, index) {
                    final item = controller.recipients[index];
                    return RecipientListCard(
                      name: item.name,
                      relationship: item.relationship,
                      tags: item.tags,
                      imageUrl: item.imageUrl,
                      onTap: () => controller.selectRecipient(item),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
