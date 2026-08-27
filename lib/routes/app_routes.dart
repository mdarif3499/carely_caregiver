class AppRoutes {
  final String editProfessionalProfileScreen = "/editProfessionalProfileScreen";

  AppRoutes._privateConstructor();
  static final AppRoutes _instance = AppRoutes._privateConstructor();
  static AppRoutes get instance => _instance;
  /////////////  initial or splash screen
  final String initial = "/";
  final String wellCome = "/wellCome";
  final String errorScreen = '/errorScreen';
  final String notFoundScreen = "/notFoundScreen";
  /////////////////////// auth related all  screen
  final String loginScreen = "/loginScreen";
  final String onBoardingScreen = "/onBoardingScreen";
  final String otpVerificationScreen = "/otp-verification";
  final String forgotScreen = "/forgot-screen";
  final String signUpScreen = "/signup-screen";
  final String changePasswordScreen = "/change-password-screen";
  final String welcomeScreen = "/welcomeScreen";
  final String basicInfoScreen = "/basicInfoScreen";
  final String profileSetUpScreen = "/profileSetUpScreen";
  final String personalInfoScreen = "/personalInfoScreen";
  final String careRecipientsScreen = "/careRecipientsScreen";
  final String newRecipientProfileScreen = "/newRecipientProfileScreen";
  //////////////////////  app  navigation
  final String appNavigationScreen = "/app-navigation-screen";
  final String clientHomeScreen = "/clientHomeScreen";
  final String careGiverDetailsScreen = "/careGiverDetailsScreen";
  final String reviewBookingScreen = "/reviewBookingScreen";
  final String bookCareGiverScreen = "/bookCareGiverScreen";
  final String caregiverDocumentsScreen = "/caregiverDocumentsScreen";
  final String messageScreen = "/messageScreen";
  final String bookingDetailsScreen = "/bookingDetailsScreen";
  final String stripePaymentWebView = "/stripePaymentWebView";
  final String clientBookingDetails = "/clientBookingDetails";
  final String allScheduleScreen = "/allScheduleScreen";
  final String fullScreenImage = "/fullScreenImage";
  final String notificationScreen = "/notificationScreen";
  final String availabilityScreen = "/availabilityScreen";
  final String bookingStatusScreen = "/bookingStatusScreen";
  final String notificationSettingsScreen = "/notificationSettingsScreen";
  ////////////////////// base
  final String termsAndConditions = "/terms-and-conditions";
  final String privacyPolicy = "/privacy-policy";
  final String aboutUs = "/about-us";
}
