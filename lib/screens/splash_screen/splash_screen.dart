import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/constant/app_asserts_image_path.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/screens/splash_screen/provider/splash_provider.dart';
import 'package:flutter_riverpod_template/utils/app_size.dart';
import 'package:flutter_riverpod_template/utils/gap.dart';
import 'package:flutter_riverpod_template/widgets/app_image/app_image.dart';
import 'package:flutter_riverpod_template/widgets/texts/app_text.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(splashProvider);

    return Scaffold(
      backgroundColor: AppColors.instance.white50,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: Gap(height: 40)),
          SliverToBoxAdapter(
            child: AppImage(

                path: AppAssertsImagePath.instance.flagIcon),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.width(value: 16),
              ),
              child: AppText(
                text: "Welcome to Dalsan Digital Market",
                fontWeight: FontWeight.w500,
                fontSize: AppSize.width(value: 30),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SliverToBoxAdapter(child: Gap(height: 15)),
          SliverToBoxAdapter(
            child: AppText(
              text: "China to Somalia",
              color: AppColors.instance.primary,
              fontSize: AppSize.width(value: 18),
              fontWeight: FontWeight.w400,
              textAlign: TextAlign.center,
            ),
          ),
          SliverToBoxAdapter(child: Gap(height: 80)),
          SliverToBoxAdapter(child: Center(child: CircularProgressIndicator(color: AppColors.instance.primary,)),),
        ],
      ),
    );
  }
}
