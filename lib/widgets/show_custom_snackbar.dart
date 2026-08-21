import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Custom Snackbar Function
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showCustomSnackbar({
  required String message,
  bool isError = true,
  String? title,
  Duration duration = const Duration(seconds: 3),
  SnackPosition position = SnackPosition.BOTTOM,
  bool isDismissible = true,
  Widget? icon,
}) {
  final Color bgColor = isError ? Colors.red : Colors.green;

  Get.snackbar(
    title ?? (isError?'Error': 'Success'),
    message,
    backgroundColor: bgColor,
    titleText: title != null
        ? CommonText(
      text: title,
      textColor: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    )
        : null,
    messageText: CommonText(
      text: message,
      textColor: Colors.white,
      fontSize: 14,
    ),
    icon: icon,
    snackPosition: position,
    duration: duration,
    isDismissible: isDismissible,
    margin: const EdgeInsets.all(10),
    borderRadius: 10,
    animationDuration: const Duration(milliseconds: 300),
    forwardAnimationCurve: Curves.easeOut,
    reverseAnimationCurve: Curves.easeIn,
  );
}
