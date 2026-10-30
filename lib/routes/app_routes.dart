import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/routes/app_routes_key.dart';
import 'package:flutter_riverpod_template/routes/internet_check_provider.dart';
import 'package:flutter_riverpod_template/screens/about/about.dart';
import 'package:flutter_riverpod_template/screens/faq/faq.dart';
import 'package:flutter_riverpod_template/screens/home_screen/home_screen.dart';
import 'package:flutter_riverpod_template/screens/onbording_screen/onboarding_screen.dart';
import 'package:flutter_riverpod_template/screens/privacy_policy_screen/privacy_policy_screen.dart';
import 'package:flutter_riverpod_template/models/product_model.dart';
import 'package:flutter_riverpod_template/screens/product_details/product_details.dart';
import 'package:flutter_riverpod_template/screens/settings_screen/settings_screen.dart';
import 'package:flutter_riverpod_template/screens/splash_screen/splash_screen.dart';
import 'package:flutter_riverpod_template/screens/terms_condition_screen/terms_condition_screen.dart';
import 'package:flutter_riverpod_template/utils/app_log.dart';
import 'package:go_router/go_router.dart';

import '../screens/base_screen/error_screen/error_screen.dart';
import '../screens/base_screen/no_internet_screen/no_internet_screen.dart';
import '../screens/base_screen/not_found_screen/not_found_screen.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRoutes {
  ////////////// constructor
  AppRoutes._privateConstructor();
  static final AppRoutes _instance = AppRoutes._privateConstructor();
  static AppRoutes get instance => _instance;
  //////////////// routes

  GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    debugLogDiagnostics: kDebugMode,
    initialLocation: AppRoutesKey.instance.initial,
    routes: [
      GoRoute(
          path: AppRoutesKey.instance.initial,
          name: AppRoutesKey.instance.splash,
          builder: (context, state) => SplashScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.onboardingScreen}",
        name: AppRoutesKey.instance.onboardingScreen,
        builder: (context, state) => OnboardingScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.notFoundScreen}",
        name: AppRoutesKey.instance.notFoundScreen,
        builder: (context, state) => NotFoundScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.noInternetScreen}",
        name: AppRoutesKey.instance.noInternetScreen,
        builder: (context, state) => const NoInternetScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.errorScreen}",
        name: AppRoutesKey.instance.errorScreen,
        builder: (context, state) => const ErrorScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.settingsScreen}",
        name: AppRoutesKey.instance.settingsScreen,
        builder: (context, state) => SettingsScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.productDetails}",
        name: AppRoutesKey.instance.productDetails,
        builder: (context, state) {
          if (state.extra is ProductModel) {
            return ProductDetails(product: state.extra as ProductModel);
          } else if (state.extra is String) {
            return ProductDetails(productId: state.extra as String);
          }
          return const ProductDetails();
        },
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.privacyPolicyScreen}",
        name: AppRoutesKey.instance.privacyPolicyScreen,
        builder: (context, state) => PrivacyPolicyScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.termsConditionScreen}",
        name: AppRoutesKey.instance.termsConditionScreen,
        builder: (context, state) => TermsConditionScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.about}",
        name: AppRoutesKey.instance.about,
        builder: (context, state) => About(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.faq}",
        name: AppRoutesKey.instance.faq,
        builder: (context, state) => Faq(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.homeScreen}",
        name: AppRoutesKey.instance.homeScreen,
        builder: (context, state) => HomeScreen(),
      ),
    ],
    errorBuilder: (context, state) {
      return NotFoundScreen();
    },
    redirect: (context, state) {
      final container = ProviderScope.containerOf(context, listen: false);
      final asyncStatus = container.read(internetStatusProvider);

      if (asyncStatus.isLoading) return null;
      if (asyncStatus.hasError) return "/${AppRoutesKey.instance.errorScreen}";

      final isOnline = asyncStatus.value ?? true;
      final goingToNoInternet = state.name == AppRoutesKey.instance.noInternetScreen ||
          state.matchedLocation == "/${AppRoutesKey.instance.noInternetScreen}";

      if (!isOnline && !goingToNoInternet) {
        return "/${AppRoutesKey.instance.noInternetScreen}";
      }

      if (isOnline && goingToNoInternet) {
        return "/${AppRoutesKey.instance.homeScreen}";
      }

      return null;
    },
  );

  ////////////////////. route operation start
  String _normalize(String value) => value.startsWith("/") ? value : "/$value";

  void go(String value) {
    try {
      router.go(_normalize(value));
    } catch (e) {
      errorLog("goNamed", e);
    }
  }

  void goNamed(
    String value, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
    String? fragment,
  }) {
    try {
      router.goNamed(value, pathParameters: pathParameters, extra: extra, fragment: fragment, queryParameters: queryParameters);
    } catch (e) {
      errorLog("goNamed", e);
    }
  }

  void replace(String value, {Object? extra}) {
    try {
      router.replace(_normalize(value), extra: extra);
    } catch (e) {
      errorLog("replaceNamed", e);
    }
  }

  void replaceNamed(
    String value, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    try {
      router.replaceNamed(value, pathParameters: pathParameters, extra: extra, queryParameters: queryParameters);
    } catch (e) {
      errorLog("replaceNamed", e);
    }
  }

  void push(
    String value, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    try {
      router.push(_normalize(value), extra: extra);
    } catch (e) {
      errorLog("push", e);
    }
  }

  void pushNamed(
    String value, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    try {
      router.pushNamed(value, pathParameters: pathParameters, extra: extra, queryParameters: queryParameters);
    } catch (e) {
      errorLog("pushNamed", e);
    }
  }

  void pushReplacement(String value, {Object? extra}) {
    try {
      router.pushReplacement(_normalize(value), extra: extra);
    } catch (e) {
      errorLog("pushReplacement", e);
    }
  }

  void pushReplacementNamed(
    String value, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    try {
      router.pushReplacementNamed(value, pathParameters: pathParameters, extra: extra, queryParameters: queryParameters);
    } catch (e) {
      errorLog("pushReplacementNamed", e);
    }
  }

  void pop() {
    try {
      GoRouter.of(rootNavigatorKey.currentContext!).pop();
    } catch (e) {
      errorLog("pop", e);
    }
  }

  ////////////////////. route operation end
}
