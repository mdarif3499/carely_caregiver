import 'package:get/get.dart';

class BasicInfoController extends GetxController{
  RxBool isClient = false.obs;

  @override
  void onInit() {
    isClient.value = Get.arguments["isClient"]??false;
    super.onInit();
  }


}