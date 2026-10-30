import 'package:flutter/material.dart';
import 'package:flutter_riverpod_template/constant/app_asserts_image_path.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/routes/app_routes.dart';
import 'package:flutter_riverpod_template/routes/app_routes_key.dart';
import 'package:flutter_riverpod_template/utils/app_size.dart';
import 'package:flutter_riverpod_template/utils/gap.dart';
import 'package:flutter_riverpod_template/widgets/app_image/app_image.dart';
import 'package:flutter_riverpod_template/widgets/buttons/app_button.dart';
import 'package:flutter_riverpod_template/widgets/texts/app_text.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/screens/onbording_screen/provider/onboarding_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = ref.watch(onboardingPageIndexProvider);

    return Scaffold(
      backgroundColor: AppColors.instance.white50,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  ref.read(onboardingPageIndexProvider.notifier).state = index;
                },
                children: [
                  _buildFirstPage(),
                  _buildSecondPage(),
                ],
              ),
            ),
            _buildBottomSection(currentPage),
            const Gap(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildFirstPage() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20)),
      child: Column(
        children: [
          const Gap(height: 40),
          AppImage(
            path: AppAssertsImagePath.instance.onBoardingIcon,
            height: AppSize.height(value: 280),
          ),
          const Gap(height: 70),
          AppText(
            text: "Welcome to Dalsan \n Digital Market!",
            fontWeight: FontWeight.w600,
            fontSize: AppSize.width(value: 26),
            textAlign: TextAlign.center,
            color: Color(0xFF031109),
          ),
          const Gap(height: 10),
          AppText(
            text: "Shop directly from China with ease.",
            fontWeight: FontWeight.w400,
            fontSize: AppSize.width(value: 16),
            textAlign: TextAlign.center,
            color: Color(0xFF2A3730),
          ),
          const Gap(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 10)),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'Get the best products from ',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: AppSize.width(value: 15),
                  height: 1.5,
                ),
                children: const <TextSpan>[
                  TextSpan(
                    text: 'China delivered to Somalia.',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: ' Browse easily and order instantly via'),
                  TextSpan(
                    text: ' WhatsApp.',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondPage() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20)),
      child: Column(
        children: [
          const Gap(height: 36),
          AppImage(
            path: AppAssertsImagePath.instance.onBoardingIcon,
            height: AppSize.height(value: 280),
          ),
         Spacer(),
          AppText(
            text: "Welcome to Dalsan \n Digital Market!",
            fontWeight: FontWeight.w600,
            fontSize: AppSize.width(value: 26),
            textAlign: TextAlign.center,
            color: Color(0xFF031109),
          ),
          const Gap(height: 10),
          AppText(
            text: "Shop directly from China with ease.",
            fontWeight: FontWeight.w400,
            fontSize: AppSize.width(value: 16),
            textAlign: TextAlign.center,
            color: Color(0xFF2A3730),
          ),
          const Gap(height: 12),
          _buildBenefitItem(
            "1. Direct Delivery from China — ",
            "We deliver your products straight to your home or workplace.",
          ),
          _buildBenefitItem(
            "2. Wholesale & Retail Prices — ",
            "Access quality products at competitive direct-from-source prices.",
          ),
          _buildBenefitItem(
            "3. Fast WhatsApp Ordering — ",
            "Easily chat, confirm details, and complete your orders instantly.",
          ),
          const Gap(height: 10),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'Start now and make the most of your \n',
              style: TextStyle(
                color: Colors.black87,
                fontSize: AppSize.width(value: 14),
              ),
              children: const <TextSpan>[
                TextSpan(
                  text: 'opportunity!',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const Gap(height: 13),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(String title, String description) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSize.height(value: 8)),
      child: RichText(
        text: TextSpan(
          text: title,
          style: TextStyle(
            color: Color(0xFF2A3730),
            fontSize: AppSize.width(value: 16),
            fontWeight: FontWeight.w400,
            height: 1.4,
          ),
          children: [
            TextSpan(
              text: description,
              style: const TextStyle(fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSection(int currentPage) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(2, (index) => _buildDot(index, currentPage)),
          ),
          const Gap(height: 30),
          AppButton(
            borderRadius: BorderRadius.circular(26),
            title: currentPage == 0 ? "Next" : "Start Shopping",
            onTap: () {
              if (currentPage == 0) {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              } else {
                AppRoutes.instance.pushNamed(AppRoutesKey.instance.homeScreen);
              }
            },
            backgroundColor: AppColors.instance.primary,
            height: AppSize.height(value: 49),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index, int currentPage) {
    bool isActive = currentPage == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(right: 5),
      height: 6,
      width: isActive ? 25 : 25,
      decoration: BoxDecoration(
        color: isActive ? AppColors.instance.primary : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
