class AppRoutesKey {
  ////////////// constructor
  AppRoutesKey._privateConstructor();
  static final AppRoutesKey _instance = AppRoutesKey._privateConstructor();
  static AppRoutesKey get instance => _instance;
  //////////////// routes
  final String initial = "/";
  final String splash = "splash";
  final String onboardingScreen = "onboardingScreen";
  final String homeScreen = "homeScreen";
  final String notFoundScreen = "notFoundScreen";
  final String errorScreen = "errorScreen";
  final String noInternetScreen = "noInternetScreen";
  final String settingsScreen = "settingsScreen";
  final String productDetails = "productDetails";
  final String privacyPolicyScreen = "privacyPolicyScreen";
  final String termsConditionScreen = "termsConditionScreen";
  final String about = "about";
  final String faq = "faq";
}
