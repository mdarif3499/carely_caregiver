import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../constant/app_colors.dart';
import '../../utils/app_size.dart';
import 'controller/on_boarding_screen_controller.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );

    return GetBuilder(
      init: OnBoardingScreenController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              Positioned.fill(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: Obx(
                  () => AnimatedSwitcher(
                    duration: const Duration(milliseconds: 600),
                    switchInCurve: Curves.easeInOut,
                    switchOutCurve: Curves.easeInOut,
                    child: SizedBox(
                      key: ValueKey<int>(controller.selectedIndex.value),
                      width: double.infinity,
                      height: double.infinity,
                      child: Stack(
                        children: [
                          CommonImage(
                            src:
                                controller.onBoardingImageList[controller
                                    .selectedIndex
                                    .value],
                            fill: BoxFit.cover,
                          ),
                          Positioned(
                            top: MediaQuery.of(context).padding.top + 8,
                            right: AppSize.width(value: 20),
                            child: InkWell(
                              onTap: () {
                                controller.onTapSkip();
                              },
                              child: CommonText(
                                text: 'Skip',
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                textColor: AppColors.instance.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // ── Bottom white card section ──────────────────────────────────
              Positioned(
                top: AppSize.size.height * 0.55,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.width(value: 24),
                  ),
                  child: Obx(
                    () => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Title
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          switchInCurve: Curves.easeInOut,
                          switchOutCurve: Curves.easeInOut,
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(0.0, 0.08),
                                      end: Offset.zero,
                                    ).animate(animation),
                                    child: child,
                                  ),
                                );
                              },
                          child: Column(
                            key: ValueKey<int>(controller.selectedIndex.value),
                            children: [
                              CommonText(
                                text: controller
                                    .onBoardingDataList[controller
                                        .selectedIndex
                                        .value]
                                    .title,
                                textAlign: TextAlign.center,
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                              ),
                              12.height,
                              CommonText(
                                maxLines: 2,
                                text: controller
                                    .onBoardingDataList[controller
                                        .selectedIndex
                                        .value]
                                    .subTitle,
                                textAlign: TextAlign.center,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                textColor: AppColors.instance.secondaryText,
                              ),
                            ],
                          ),
                        ),

                        24.height,
                        // Dot indicators
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            controller.onBoardingDataList.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              width: controller.selectedIndex.value == index
                                  ? AppSize.width(value: 28)
                                  : AppSize.width(value: 8),
                              height: AppSize.height(value: 8),
                              margin: EdgeInsets.symmetric(
                                horizontal: AppSize.width(value: 4),
                              ),
                              decoration: BoxDecoration(
                                color: controller.selectedIndex.value == index
                                    ? AppColors.instance.primary
                                    : const Color(0xFFD1D1D1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: AppSize.height(value: 24)),

                        // Next button
                        CommonButton(
                          titleText: 'Next',
                          onTap: controller.onTapNext,
                        ),

                        // Bottom home indicator spacing
                        12.height,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
