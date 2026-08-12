import 'package:carely_caregiver/routes/app_routes.dart';
import 'package:carely_caregiver/services/share_pref_helper/share_pref_helper.dart';
import 'package:get/get.dart';

// ── Controller ───────────────────────────────────────────
class ProfileScreenController extends GetxController {
  // ── User info (wire to your auth/user service later) ──
  final RxString name = 'Sarah Henderson'.obs;
  final RxString avatarUrl =
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400'.obs;
  final RxString memberSince = 'Member since January 2023'.obs;


  void logout() async {
    await SharePrefsHelper.clearData();
    Get.offAllNamed(AppRoutes.instance.loginScreen);
  }
}
