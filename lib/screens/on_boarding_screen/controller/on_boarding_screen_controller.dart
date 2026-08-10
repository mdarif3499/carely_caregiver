import 'package:get/get.dart';

import '../../../gen/assets.gen.dart';
import '../../../routes/app_routes.dart';

class OnBoardingScreenController extends GetxController {
  RxInt selectedIndex = 0.obs;
  List<OnBoardingDataModel> onBoardingDataList = [
    OnBoardingDataModel(
      title: "Ride, Your Rules",
      subTitle:
          "Book rides easily, enjoy transparent pricing, and take control of your travel experience. Safe, fair, and simple.",
    ),
    OnBoardingDataModel(
      title: "Freedom & Convenience",
      subTitle:"Drivers choose where and when to work. Passengers get quick rides with clear fares and verified drivers."
    ),
    OnBoardingDataModel(
      title: "Safe & Reliable",
      subTitle:"Track rides in real-time, verify IDs, and enjoy a trustworthy travel experience anytime, anywhere."
    ),
  ];
  List<String>onBoardingImageList=[
    Assets.images.splashBg.path,
    Assets.images.onboarding1.path,
    Assets.images.onboarding2.path,

  ];

  void onTapNext() {
    if (selectedIndex.value < onBoardingDataList.length - 1) {
      selectedIndex.value++;
    } else {
      Get.offAllNamed(AppRoutes.instance.loginScreen);
    }
  }

  void onTapSkip() {
    Get.offAllNamed(AppRoutes.instance.loginScreen);
  }
}

class OnBoardingDataModel {
  String title;
  String subTitle;

  OnBoardingDataModel({required this.title, required this.subTitle});
}
