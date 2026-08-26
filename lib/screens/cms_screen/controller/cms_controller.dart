import 'package:carely_caregiver/models/cms_model.dart';
import 'package:carely_caregiver/repositories/cms_repository.dart';
import 'package:carely_caregiver/widgets/show_custom_snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class CMSController extends GetxController {
  final RxBool isLoading = false.obs;
  final Rxn<CMSModel> cmsData = Rxn<CMSModel>();
  
  final String slug;
  CMSController({required this.slug});

  @override
  void onInit() {
    super.onInit();
    fetchCMSPage();
  }

  Future<void> fetchCMSPage() async {
    try {
      isLoading.value = true;
      update();

      final response = await CMSRepository.instance.getPage(slug);

      if (response.isSuccess) {
        cmsData.value = CMSModel.fromJson(response.data['data'] ?? {});
      } else {
        showCustomSnackbar(message: response.message, isError: true);
      }
    } catch (e) {
      debugPrint("Error fetching CMS page ($slug): $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }
}
