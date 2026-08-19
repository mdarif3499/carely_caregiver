import 'package:get/get.dart';
import '../../screens/chat_list_screen/controller/chat_list_controller.dart';
import '../../screens/message_screen/controller/message_screen_controller.dart';

class MessageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChatListController(), fenix: true);
    Get.lazyPut(() => MessageScreenController(), fenix: true);
  }
}
