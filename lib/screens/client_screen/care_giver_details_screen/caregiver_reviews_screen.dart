import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:carely_caregiver/screens/client_screen/care_giver_details_screen/controller/care_giver_details_controller.dart';
import 'package:carely_caregiver/widgets/default_background_template.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CaregiverReviewsScreen extends StatefulWidget {
  const CaregiverReviewsScreen({super.key});

  @override
  State<CaregiverReviewsScreen> createState() => _CaregiverReviewsScreenState();
}

class _CaregiverReviewsScreenState extends State<CaregiverReviewsScreen> {
  late final CareGiverDetailsController controller;
  late final String caregiverId;
  late final String caregiverName;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    controller = Get.find<CareGiverDetailsController>();
    final arguments = Get.arguments;
    if (arguments is Map) {
      caregiverId = arguments['caregiverId']?.toString() ?? '';
      caregiverName = arguments['caregiverName']?.toString() ?? 'Caregiver';
    } else {
      caregiverId = arguments is String ? arguments : '';
      caregiverName = '';
    }
    _scrollController.addListener(_loadWhenNearEnd);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.prepareCaregiverReviews(caregiverId);
    });
  }

  void _loadWhenNearEnd() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.extentAfter < 300) {
      controller.loadMoreCaregiverReviews();
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_loadWhenNearEnd)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;

    return DefaultBackgroundTemplate(
      appBarTitle: 'Caregiver Reviews',
      child: Obx(() {
        final reviews = controller.caregiverReviews;
        final count = controller.totalCaregiverReviews.value;
        final shouldShowFooter = reviews.isEmpty ||
            controller.isReviewsLoading.value ||
            controller.hasMoreCaregiverReviews.value ||
            controller.caregiverReviewsError.value.isNotEmpty;

        return RefreshIndicator(
          onRefresh: controller.refreshCaregiverReviews,
          child: ListView.builder(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 24.h),
            itemCount: 1 + reviews.length + (shouldShowFooter ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == 0) {
                final profile = controller.caregiverProfile.value;
                final displayCount =
                    count > 0 ? count : profile?.totalReviews ?? 0;
                return Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText(
                        text: caregiverName.isNotEmpty
                            ? caregiverName
                            : profile?.name ?? 'Caregiver',
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w700,
                        textColor: colors.textPrimary,
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(height: 4.h),
                      CommonText(
                        text: displayCount == 0
                            ? 'Reviews'
                            : '${NumberFormat.decimalPattern().format(displayCount)} reviews',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        textColor: colors.secondaryText,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                );
              }

              final reviewIndex = index - 1;
              if (reviewIndex < reviews.length) {
                return _ReviewCard(review: reviews[reviewIndex]);
              }

              if (reviews.isEmpty &&
                  controller.caregiverReviewsError.value.isEmpty &&
                  controller.isReviewsLoading.value) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (controller.caregiverReviewsError.value.isNotEmpty) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.h),
                  child: Center(
                    child: Column(
                      children: [
                        CommonText(
                          text: controller.caregiverReviewsError.value,
                          fontSize: 14.sp,
                          textColor: colors.secondaryText,
                          textAlign: TextAlign.center,
                        ),
                        TextButton(
                          onPressed: controller.loadMoreCaregiverReviews,
                          child: const Text('Try again'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (reviews.isEmpty) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.h),
                  child: Center(
                    child: CommonText(
                      text: 'No reviews yet.',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      textColor: colors.secondaryText,
                    ),
                  ),
                );
              }

              if (controller.isReviewsLoading.value) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (controller.hasMoreCaregiverReviews.value) {
                return Center(
                  child: TextButton(
                    onPressed: controller.loadMoreCaregiverReviews,
                    child: const Text('Load more reviews'),
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        );
      }),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final CaregiverReview review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.boxBg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: colors.boxBg,
                backgroundImage: review.clientImage.isNotEmpty
                    ? NetworkImage(review.clientImage)
                    : null,
                child: review.clientImage.isEmpty
                    ? Icon(Icons.person_outline,
                        color: colors.primary, size: 22.sp)
                    : null,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      text: review.clientName,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      textColor: colors.textPrimary,
                      textAlign: TextAlign.start,
                    ),
                    if (review.createdAt != null)
                      CommonText(
                        text:
                            DateFormat('MMM d, yyyy').format(review.createdAt!),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        textColor: colors.secondaryText,
                        textAlign: TextAlign.start,
                      ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < review.rating
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: Colors.amber,
                    size: 16.sp,
                  ),
                ),
              ),
            ],
          ),
          if (review.comment.isNotEmpty) ...[
            SizedBox(height: 12.h),
            CommonText(
              text: review.comment,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              textColor: colors.textPrimary,
              textAlign: TextAlign.start,
              height: 1.4,
            ),
          ],
        ],
      ),
    );
  }
}
