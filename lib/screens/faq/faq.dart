import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/providers/page_provider.dart';
import 'package:flutter_riverpod_template/utils/app_size.dart';
import 'package:flutter_riverpod_template/utils/gap.dart';
import 'package:flutter_riverpod_template/widgets/buttons/icon_button_widget.dart';
import 'package:flutter_riverpod_template/widgets/custom_expansion_tile/custom_expansion_tile.dart';
import 'package:flutter_riverpod_template/widgets/texts/app_text.dart';

class Faq extends ConsumerWidget {
  const Faq({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final faqsAsync = ref.watch(faqsProvider);

    return Scaffold(
      backgroundColor: AppColors.instance.white50,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Custom Header
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.width(value: 20),
                  vertical: AppSize.height(value: 20),
                ),
                child: Row(
                  children: [
                    IconButtonWidget(
                      icon: Icons.keyboard_double_arrow_left,
                      onTap: () => Navigator.pop(context),
                    ),
                    const Gap(width: 15),
                    AppText(
                      text: "FAQ",
                      fontSize: AppSize.width(value: 32),
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              ),
            ),

            // Main FAQ Container
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20)),
              sliver: SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.all(AppSize.width(value: 16)),
                  decoration: BoxDecoration(
                    color: AppColors.instance.grayContainer,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: "Frequently Asked\nQuestions",
                        fontSize: AppSize.width(value: 24),
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                      const Gap(height: 20),
                      faqsAsync.when(
                        data: (faqs) {
                          if (faqs.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 32),
                              child: Center(
                                child: AppText(
                                  text: "No FAQs available at the moment.",
                                  fontSize: 16,
                                ),
                              ),
                            );
                          }
                          return Column(
                            children: faqs.map((item) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: AppSize.height(value: 12)),
                                child: CustomExpansionTile(
                                  tapHeaderToExpand: false,
                                  padding: EdgeInsets.all(AppSize.width(value: 16)),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.05),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  title: AppText(
                                    text: item.question,
                                    fontSize: AppSize.width(value: 16),
                                    fontWeight: FontWeight.w600,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: AppSize.height(value: 8),
                                        left: AppSize.width(value: 2),
                                      ),
                                      child: AppText(
                                        text: item.answer,
                                        fontSize: AppSize.width(value: 14),
                                        color: AppColors.instance.gray50,
                                        maxLines: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          );
                        },
                        loading: () => Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: CircularProgressIndicator(color: AppColors.instance.primary),
                          ),
                        ),
                        error: (error, stack) => Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              children: [
                                const Icon(Icons.error_outline, color: Colors.red, size: 40),
                                const Gap(height: 10),
                                const AppText(text: "Failed to load FAQs", fontSize: 16, color: Colors.red),
                                const Gap(height: 10),
                                GestureDetector(
                                  onTap: () => ref.invalidate(faqsProvider),
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: AppColors.instance.primary,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      child: AppText(text: "Retry", fontSize: 14, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: Gap(height: 30)),
          ],
        ),
      ),
    );
  }
}
