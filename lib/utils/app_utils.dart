import 'package:flutter/material.dart';
import 'error_log.dart';

class AppUtils {
  AppUtils._();

  static String formatSecondFunction(int seconds) {
    try {
      int minutes = (seconds % 3600) ~/ 60;
      int secs = seconds % 60;
      String formattedMinutes = minutes.toString().padLeft(2, '0');
      String formattedSeconds = secs.toString().padLeft(2, '0');
      return "$formattedMinutes:$formattedSeconds";
    } catch (e) {
      errorLog("formatSecondFunction", e);
      return "00:00";
    }
  }

  static String maskEmail(String email) {
    try {
      List<String> parts = email.split('@');
      if (parts.length == 2) {
        return "****@${parts[1]}";
      }
    } catch (e) {
      errorLog("maskEmail", e);
    }
    return email;
  }

  static void closeKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return "Good Morning";
    } else if (hour >= 12 && hour < 17) {
      return "Good Afternoon";
    } else if (hour >= 17 && hour < 21) {
      return "Good Evening";
    } else {
      return "Good Night";
    }
  }
}
