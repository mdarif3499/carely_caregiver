import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carely_caregiver/services/connectivity_service/connectivity_service.dart';
import 'package:carely_caregiver/services/socket/socket_service.dart';
import 'constant/app_colors.dart';
import 'main_entry_app.dart';

String? userTimezone;
Future<void> main() async {
  //////////////  flutter binding initialize
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  ///////////// internet connectivity status check
  await ConnectivityService().initConnectivity();
  ///////////// devices orientation set
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  //////////// app navigation style set
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(systemNavigationBarColor: AppColors.instance.transparent, statusBarColor: AppColors.instance.transparent, systemNavigationBarDividerColor: Colors.transparent),
  );

  // Initialize Socket connection early
  SocketService.connect();

  /////////  flutter main widget call

  runApp(const MainEntryApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
