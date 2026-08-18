import 'package:get/get.dart';
import '../../services/connectivity_service/connectivity_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ConnectivityService(), permanent: true);
  }
}
