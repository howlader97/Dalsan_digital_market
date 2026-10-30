import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/routes/app_routes.dart';
import 'package:flutter_riverpod_template/routes/app_routes_key.dart';

final splashProvider = AsyncNotifierProvider<SplashProvider, void>(() {
  return SplashProvider();
});

class SplashProvider extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    await Future.delayed(const Duration(seconds: 3));
    AppRoutes.instance.goNamed(AppRoutesKey.instance.onboardingScreen);
  }
}
