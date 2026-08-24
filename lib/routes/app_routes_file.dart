import 'package:carely_caregiver/screens/auth_all_screens/welcome_screen/welcome_screen.dart';
import 'package:carely_caregiver/screens/care_giver_screens/availability_screen/availability_screen.dart';
import 'package:carely_caregiver/screens/care_giver_screens/booking_details_screen/booking_details_screen.dart';
import 'package:carely_caregiver/screens/client_screen/book_caregiver_screen/book_caregiver_screen.dart';
import 'package:carely_caregiver/screens/client_screen/care_giver_details_screen/care_giver_details_screen.dart';
import 'package:carely_caregiver/screens/client_screen/client_home_screen.dart';
import 'package:carely_caregiver/screens/client_screen/review_booking_screen/review_booking_screen.dart';
import 'package:carely_caregiver/screens/message_screen/message_screen.dart';
import 'package:carely_caregiver/screens/notification_screen/notification_screen.dart';
import 'package:carely_caregiver/screens/profile_screens/basic_info_screen/basic_info_screen.dart';
import 'package:carely_caregiver/screens/client_screen/care_recipients_screen/care_recipients_screen.dart';
import 'package:carely_caregiver/screens/care_giver_screens/all_schedule_screen/all_schedule_screen.dart';
import 'package:carely_caregiver/screens/client_screen/new_recipient_profile_screen/new_recipient_profile_screen.dart';
import 'package:carely_caregiver/screens/client_screen/payment/stripe_webview_screen.dart';
import 'package:carely_caregiver/screens/profile_screens/notification_settings_screen/notification_settings_screen.dart';
import 'package:carely_caregiver/screens/profile_screens/personal_information_screen/personal_info_screen.dart';
import 'package:carely_caregiver/screens/profile_screens/profile_setup_screen/profile_setup_screen.dart';
import 'package:carely_caregiver/screens/client_screen/booking_status_screen/booking_status_screen.dart';
import 'package:get/get.dart';
import 'package:carely_caregiver/screens/profile_screens/edit_professional_profile_screen/edit_professional_profile_screen.dart';
import 'package:carely_caregiver/screens/on_boarding_screen/on_boarding_screen.dart';
import '../screens/about_us_screen/about_us_screen.dart';
import '../screens/app_navigation_screen/app_navigation_screen.dart';
import '../screens/auth_all_screens/change_password_screen/change_password_screen.dart';
import '../screens/auth_all_screens/forgot_screen/forgot_screen.dart';
import '../screens/auth_all_screens/login_screen/login_screen.dart';
import '../screens/auth_all_screens/otp_verification_screen/otp_verification_screen.dart';
import '../screens/auth_all_screens/sign_up_screen/sign_up_screen.dart';
import '../screens/error_screen/error_screen.dart';
import '../screens/privacy_policy_screen/privacy_policy_screen.dart';
import '../screens/splash_screen/splash_screen.dart';
import '../screens/terms_and_conditions_screen/terms_and_conditions_screen.dart';
import 'app_routes.dart';
import 'bindings/auth_binding.dart';
import 'bindings/care_giver_home_binding.dart';
import 'bindings/client_home_binding.dart';
import 'bindings/message_binding.dart';
import 'bindings/navigation_screen_binding.dart';
import 'bindings/profile_binding.dart';
import 'bindings/splash_screen_binding.dart';
import 'internet_check_middle_ware.dart';

List<GetPage> appRootRoutesFile = <GetPage>[
  /////////////////  splash screen start
  GetPage(
    name: AppRoutes.instance.initial,
    binding: SplashScreenBinding(),
    page: () => const SplashScreen(),
  ),
  GetPage(
    name: AppRoutes.instance.errorScreen,
    binding: SplashScreenBinding(),
    page: () => const ErrorScreen(),
  ),
  GetPage(
    name: AppRoutes.instance.notFoundScreen,
    binding: SplashScreenBinding(),
    page: () => const ErrorScreen(),
  ),
  ///////////////////////  auth all start
  GetPage(
    name: AppRoutes.instance.loginScreen,
    binding: AuthBinding(),
    page: () => const LoginScreen(),
    middlewares: [InternetCheckMiddleWare()],
  ),
  GetPage(
    name: AppRoutes.instance.onBoardingScreen,
    binding: AuthBinding(),
    page: () => const OnBoardingScreen(),
    middlewares: [InternetCheckMiddleWare()],
  ),
  GetPage(
    name: AppRoutes.instance.forgotScreen,
    binding: AuthBinding(),
    page: () => const ForgotScreen(),
    middlewares: [InternetCheckMiddleWare()],
  ),
  GetPage(
    name: AppRoutes.instance.signUpScreen,
    binding: AuthBinding(),
    page: () => const SignUpScreen(),
    middlewares: [InternetCheckMiddleWare()],
  ),
  GetPage(
    name: AppRoutes.instance.otpVerificationScreen,
    binding: AuthBinding(),
    page: () => const OtpVerificationScreen(),
    middlewares: [InternetCheckMiddleWare()],
  ),
  GetPage(
    name: AppRoutes.instance.changePasswordScreen,
    binding: AuthBinding(),
    page: () => const ChangePasswordScreen(),
    middlewares: [InternetCheckMiddleWare()],
  ),
  GetPage(
    name: AppRoutes.instance.welcomeScreen,
    binding: AuthBinding(),
    page: () => const WelcomeScreen(),
    middlewares: [InternetCheckMiddleWare()],
  ),
  GetPage(
    name: AppRoutes.instance.basicInfoScreen,
    binding: ProfileBinding(),
    page: () => const BasicInfoScreen(),
    middlewares: [InternetCheckMiddleWare()],
  ),
  GetPage(
    name: AppRoutes.instance.profileSetUpScreen,
    binding: ProfileBinding(),
    page: () => const ProfileSetupScreen(),
    middlewares: [InternetCheckMiddleWare()],
  ),
  GetPage(
    name: AppRoutes.instance.personalInfoScreen,
    binding: ProfileBinding(),
    page: () => const PersonalInfoScreen(),
    middlewares: [InternetCheckMiddleWare()],
  ),
  GetPage(
    name: AppRoutes.instance.notificationSettingsScreen,
    binding: ProfileBinding(),
    page: () => const NotificationSettingsScreen(),
    middlewares: [InternetCheckMiddleWare()],
  ),
  GetPage(
    name: AppRoutes.instance.careRecipientsScreen,
    binding: ClientHomeBinding(),
    page: () => const CareRecipientsScreen(),
    middlewares: [InternetCheckMiddleWare()],
  ),
  GetPage(
    name: AppRoutes.instance.newRecipientProfileScreen,
    binding: ClientHomeBinding(),
    page: () => const NewRecipientProfileScreen(),
    middlewares: [InternetCheckMiddleWare()],
  ),

  GetPage(
    name: AppRoutes.instance.appNavigationScreen,
    bindings: [
      NavigationScreenBinding(),
      ClientHomeBinding(),
      CareGiverHomeBinding(),
      ProfileBinding(),
      MessageBinding(),
    ],
    page: () => const AppNavigationScreen(),
    middlewares: [InternetCheckMiddleWare()],
  ),
  GetPage(
    name: AppRoutes.instance.termsAndConditions,
    binding: ProfileBinding(),
    page: () => const TermsAndConditionsScreen(),
    middlewares: [InternetCheckMiddleWare()],
  ),
  GetPage(
    name: AppRoutes.instance.privacyPolicy,
    binding: ProfileBinding(),
    page: () => const PrivacyPolicyScreen(),
    middlewares: [InternetCheckMiddleWare()],
  ),
  GetPage(
    name: AppRoutes.instance.aboutUs,
    binding: ProfileBinding(),
    page: () => const AboutUsScreen(),
    middlewares: [InternetCheckMiddleWare()],
  ),
  GetPage(
    name: AppRoutes.instance.clientHomeScreen,
    binding: ClientHomeBinding(),
    page: () => const ClientHomeScreen(),
    middlewares: [InternetCheckMiddleWare()],
  ),
  GetPage(
    name: AppRoutes.instance.careGiverDetailsScreen,
    binding: ClientHomeBinding(),
    page: () => const CareGiverDetailsScreen(),
    middlewares: [InternetCheckMiddleWare()],
  ),

  GetPage(
    name: AppRoutes.instance.reviewBookingScreen,
    binding: ClientHomeBinding(),
    page: () => const ReviewBookingScreen(),
    middlewares: [InternetCheckMiddleWare()],
  ),

  GetPage(
    name: AppRoutes.instance.bookCareGiverScreen,
    binding: ClientHomeBinding(),
    page: () => const BookCaregiverScreen(),
    middlewares: [InternetCheckMiddleWare()],
  ),

  GetPage(
    name: AppRoutes.instance.stripePaymentWebView,
    page: () => const StripeWebViewScreen(),
    middlewares: [InternetCheckMiddleWare()],
  ),
  GetPage(
    name: AppRoutes.instance.allScheduleScreen,
    page: () => const AllScheduleScreen(),
    middlewares: [InternetCheckMiddleWare()],
  ),

  GetPage(
    name: AppRoutes.instance.messageScreen,
    binding: MessageBinding(),
    page: () => const MessageScreen(),
    middlewares: [InternetCheckMiddleWare()],
  ),

  GetPage(
    name: AppRoutes.instance.bookingDetailsScreen,
    binding: CareGiverHomeBinding(),
    page: () => const BookingDetailsScreen(),
    middlewares: [InternetCheckMiddleWare()],
  ),

  GetPage(
    name: AppRoutes.instance.notificationScreen,
    binding: NavigationScreenBinding(),
    page: () => const NotificationScreen(),
    middlewares: [InternetCheckMiddleWare()],
  ),

  GetPage(
    name: AppRoutes.instance.availabilityScreen,
    binding: CareGiverHomeBinding(),
    page: () => const AvailabilityScreen(),
    middlewares: [InternetCheckMiddleWare()],
  ),

  GetPage(
    name: AppRoutes.instance.bookingStatusScreen,
    binding: CareGiverHomeBinding(),
    page: () => const BookingStatusScreen(),
    middlewares: [InternetCheckMiddleWare()],
  ),
  GetPage(
    name: AppRoutes.instance.editProfessionalProfileScreen,
    page: () => const EditProfessionalProfileScreen(),
  ),
  /////////////////////  app base end
];
