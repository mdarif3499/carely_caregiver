import 'package:get/get.dart';

class NotificationSettingsController extends GetxController {
  final RxBool enableNotifications = true.obs;
  final RxBool bookingAlerts = true.obs;
  final RxBool paymentAlerts = true.obs;
  final RxBool messages = true.obs;

  void toggleEnableNotifications(bool value) => enableNotifications.value = value;
  void toggleBookingAlerts(bool value) => bookingAlerts.value = value;
  void togglePaymentAlerts(bool value) => paymentAlerts.value = value;
  void toggleMessages(bool value) => messages.value = value;
}
