import 'package:carely_caregiver/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carely_caregiver/constant/app_api_end_point.dart';
import 'package:carely_caregiver/routes/app_routes_file.dart';
import 'package:carely_caregiver/services/share_pref_helper/share_pref_helper.dart';
import 'package:carely_caregiver/utils/app_theme.dart';
import 'package:core_kit/core_kit.dart';

GlobalKey<NavigatorState>? appNavigatorStateKey = GlobalKey<NavigatorState>();
// Initialize a ScaffoldMessenger key that will be used by core_kit (and the app)
final GlobalKey<ScaffoldMessengerState> appScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class MainEntryApp extends StatelessWidget {
  const MainEntryApp({super.key});
  @override
  Widget build(BuildContext context) {
    // Ensure core_kit has its scaffold messenger key assigned before any widgets that rely on it mount
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.zoom,
      initialRoute: AppRoutes.instance.initial,
      getPages: appRootRoutesFile,
      theme: appThemeData,
      themeMode: ThemeMode.light,
      enableLog: true,
      defaultGlobalState: true,
      transitionDuration: const Duration(microseconds: 100),
      // Provide the scaffold messenger key to the app so Snackbars and other messenger features work reliably
      scaffoldMessengerKey: appScaffoldMessengerKey,
      builder: (context, child) {
        return CoreKit.init(
          appbarConfig: AppbarConfig(
              titleAlignment: Alignment.topLeft,
              onBack: (){
              Get.back();
            },
            backButton: const Icon(Icons.arrow_back_ios)
            // backIcon:
          ),



          designSize: const Size(393, 690),
          imageBaseUrl: AppApiEndPoint.instance.baseUrl,
          navigatorKey: Get.key,
          dioServiceConfig: DioServiceConfig(
            baseUrl: AppApiEndPoint.instance.baseUrl,
            refreshTokenEndpoint: AppApiEndPoint.instance.refreshToken,
            onLogout: () {
              // context.read<AuthCubit>().clearTokens();
              SharePrefsHelper.clearData();
            },
            enableDebugLogs: true,
          ),
          tokenProvider: TokenProvider(
            accessToken: () async => (await SharePrefsHelper.getString(SharedPreferenceValue.token)),
            refreshToken: () async {
              AppLogger.debug(
                (await SharePrefsHelper.getString(SharedPreferenceValue.refreshToken)).toString(),
                tag: 'refreshToken',
              );
              return (await SharePrefsHelper.getString(SharedPreferenceValue.refreshToken)) ?? '';
            },
            updateTokens: (data) async {
              AppLogger.debug('Update Tokens', tag: 'updateTokens');
              // await context.read<AuthCubit>().updateTokens(
              //   data['accessToken'],
              //   data['refreshToken'],
              // );
            },
          ),
          child: child,
        );
      },
    );
  }
}
