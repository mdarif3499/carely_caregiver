import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carely_caregiver/screens/auth_all_screens/forgot_screen/screens/forgot_email_input_screen.dart';
import 'package:carely_caregiver/screens/auth_all_screens/forgot_screen/screens/forgot_otp_input_screen.dart';
import 'package:carely_caregiver/screens/auth_all_screens/forgot_screen/screens/forgot_screen_create_password_screen.dart';

import 'controller/forgot_screen_controller.dart';

class ForgotScreen extends StatelessWidget {
  const ForgotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ForgotScreenController>();
    return Scaffold(
      appBar: AppBar(),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller.pageController,
        children: const [ForgotEmailInputScreen(), ForgotOtpInputScreen(), ForgotScreenCreatePasswordScreen()],
      ),
    );
  }
}
