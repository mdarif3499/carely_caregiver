import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:carely_caregiver/screens/client_screen/review_booking_screen/controller/submit_booking_review_controller.dart';
import 'package:carely_caregiver/widgets/default_background_template.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubmitBookingReviewScreen extends StatelessWidget {
  const SubmitBookingReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SubmitBookingReviewController>();
    final colors = AppColors.instance;

    return DefaultBackgroundTemplate(
      appBarTitle: 'Write a Review',
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: colors.primary.withAlpha(45), width: 2),
                    ),
                    child: CircleAvatar(
                      radius: 46,
                      backgroundColor: colors.boxBg,
                      backgroundImage: controller.caregiverAvatar.isNotEmpty
                          ? NetworkImage(controller.caregiverAvatar)
                          : null,
                      child: controller.caregiverAvatar.isEmpty
                          ? Icon(Icons.person_outline_rounded,
                              size: 44, color: colors.primary)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CommonText(
                    text: 'How was your experience?',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    textColor: colors.textPrimary,
                  ),
                  const SizedBox(height: 8),
                  CommonText(
                    text:
                        'Share your feedback about ${controller.caregiverName}',
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    textColor: colors.secondaryText,
                  ),
                  const SizedBox(height: 28),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 12),
                    decoration: BoxDecoration(
                      color: colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: colors.boxBg),
                    ),
                    child: Column(
                      children: [
                        CommonText(
                          text: 'Rate your caregiver',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          textColor: colors.textPrimary,
                        ),
                        const SizedBox(height: 12),
                        Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(5, (index) {
                              final star = index + 1;
                              return IconButton(
                                tooltip: '$star star${star == 1 ? '' : 's'}',
                                onPressed: () => controller.rating.value = star,
                                icon: Icon(
                                  star <= controller.rating.value
                                      ? Icons.star_rounded
                                      : Icons.star_outline_rounded,
                                  color: Colors.amber.shade700,
                                  size: 38,
                                ),
                              );
                            }),
                          ),
                        ),
                        Obx(
                          () => CommonText(
                            text: _ratingLabel(controller.rating.value),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            textColor: colors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CommonText(
                      text: 'Your review',
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      textColor: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: controller.commentController,
                    minLines: 5,
                    maxLines: 7,
                    maxLength: 500,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: 'Tell us what went well and what stood out...',
                      hintStyle: TextStyle(color: colors.secondaryText),
                      filled: true,
                      fillColor: colors.white,
                      alignLabelWithHint: true,
                      contentPadding: const EdgeInsets.all(16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: colors.boxBg),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: colors.boxBg),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide:
                            BorderSide(color: colors.primary, width: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
            decoration: BoxDecoration(
              color: colors.white,
              border: Border(top: BorderSide(color: colors.boxBg)),
            ),
            child: Obx(
              () => CommonButton(
                titleText: controller.isSubmitting.value
                    ? 'Submitting...'
                    : 'Submit Review',
                onTap: controller.submitReview,
                prefix: const Icon(Icons.send_rounded,
                    color: Colors.white, size: 18),
                buttonWidth: double.infinity,
                buttonHeight: 56,
                buttonRadius: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _ratingLabel(int rating) {
    switch (rating) {
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Very good';
      case 5:
        return 'Excellent';
      default:
        return 'Tap a star to rate';
    }
  }
}
