import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';
import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:carely_caregiver/gen/assets.gen.dart';
import '../../utils/app_size.dart';
import 'controller/splash_screen_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    AppSize.size = size;

    return GetBuilder(
      init: SplashScreenController(),
      builder: (controller) {
        return Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: [
              CommonImage(
                src: Assets.images.splashBg.path,
                height: size.height,
                width: size.width,
              ),

              Obx(
                    () => Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSize.width(value: 20.0),
                    ),
                    child: AnimatedOpacity(
                      duration: const Duration(seconds: 2),
                      opacity: controller.animation2.value,
                      child: AnimatedScale(
                        scale: controller.animation.value,
                        duration: const Duration(seconds: 2),
                        curve: Curves.easeOutExpo,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  width: 1.5,
                                ),

                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 28,
                                vertical: 32,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CommonImage(
                                    src: Assets.logo.appLogoPng.path,
                                    height: 150,
                                    width: 270,
                                  ),

                                  24.height,

                                  RichText(
                                    text: TextSpan(
                                      text: 'Carely ',
                                      style:  TextStyle(
                                        fontSize: 32,
                                        color: AppColors.instance.primary,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.5,
                                      ),
                                      children:  const [
                                        TextSpan(
                                          text: 'Caregiver',
                                          style: TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.w400,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  8.height,


                                  CommonText(
                                    text: 'Empowering your care journey',
                                    fontSize: 16,
                                    textColor: AppColors.instance.subTextColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
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