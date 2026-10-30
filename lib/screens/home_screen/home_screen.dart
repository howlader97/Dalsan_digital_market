import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/constant/app_asserts_icons_path.dart';
import 'package:flutter_riverpod_template/constant/app_asserts_image_path.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/routes/app_routes.dart';
import 'package:flutter_riverpod_template/routes/app_routes_key.dart';
import 'package:flutter_riverpod_template/screens/home_screen/provider/home_provider.dart';
import 'package:flutter_riverpod_template/screens/home_screen/provider/select_item_provider.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/custom_selected_option.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/product_container.dart';
import 'package:flutter_riverpod_template/utils/app_size.dart';
import 'package:flutter_riverpod_template/utils/gap.dart';
import 'package:flutter_riverpod_template/widgets/app_image/app_image.dart';
import 'package:flutter_riverpod_template/widgets/texts/app_text.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late final TextEditingController _searchController;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (mounted) {
        ref.read(searchQueryProvider.notifier).state = query;
      }
    });
    setState(() {});
  }

  void _clearSearch() {
    _debounce?.cancel();
    _searchController.clear();
    ref.read(searchQueryProvider.notifier).state = '';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final productsAsync = ref.watch(productsProvider);
    final select = ref.watch(selectItemProvider);
    final currentSearch = ref.watch(searchQueryProvider);

    return Scaffold(
      backgroundColor: AppColors.instance.white50,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header section with logo and search
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.width(value: 16),
                  vertical: AppSize.width(value: 18),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.instance.grayContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              AppImage(
                                path: AppAssertsImagePath.instance.dalsanImage,
                                width: AppSize.width(value: 90),
                                height: AppSize.height(value: 40),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  AppRoutes.instance.pushNamed(AppRoutesKey.instance.settingsScreen);
                                },
                                child: AppImage(
                                  path: AppAssertsIconsPath.instance.drawer,
                                  width: 42,
                                  height: 42,
                                ),
                              ),
                            ],
                          ),
                          const Gap(height: 30),
                          TextField(
                            controller: _searchController,
                            onChanged: _onSearchChanged,
                            onSubmitted: (value) {
                              _debounce?.cancel();
                              ref.read(searchQueryProvider.notifier).state = value;
                            },
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: "Search by Product Name",
                              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
                              prefixIcon: const Icon(Icons.search, color: Colors.white70),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear, color: Colors.white70),
                                      onPressed: _clearSearch,
                                    )
                                  : const Icon(Icons.drag_handle_sharp, color: Colors.white70),
                              filled: true,
                              fillColor: AppColors.instance.dark2A,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Sticky category tabs
            SliverPersistentHeader(
              pinned: true,
              delegate: _StickyCategoryDelegate(
                child: Container(
                  color: AppColors.instance.white50,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.instance.grayContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: SizedBox(
                        height: 42,
                        child: categoriesAsync.when(
                          data: (categories) {
                            final tabNames = ["For you", ...categories.map((c) => c.name)];
                            return ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: tabNames.length,
                              itemBuilder: (context, index) {
                                return CustomSelectedOption(
                                  title: tabNames[index],
                                  onTap: () {
                                    ref.read(selectItemProvider.notifier).changeItem(index);
                                    if (index == 0) {
                                      ref.read(selectedCategoryIdProvider.notifier).state = null;
                                    } else {
                                      ref.read(selectedCategoryIdProvider.notifier).state = categories[index - 1].id;
                                    }
                                  },
                                  isSelected: select == index,
                                );
                              },
                            );
                          },
                          loading: () => Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.instance.primary),
                            ),
                          ),
                          error: (error, stack) => Center(
                            child: AppText(text: "Failed to load categories", fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Product grid
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.width(value: 16),
                vertical: AppSize.width(value: 18),
              ),
              sliver: SliverToBoxAdapter(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.instance.grayContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: productsAsync.when(
                      data: (products) {
                        if (products.isEmpty) {
                          return SizedBox(
                            height: 200,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.inventory_2_outlined, size: 48, color: AppColors.instance.gray300),
                                  const Gap(height: 10),
                                  AppText(
                                    text: currentSearch.trim().isNotEmpty
                                        ? 'No products found for "$currentSearch"'
                                        : "No products found",
                                    fontSize: 16,
                                    color: AppColors.instance.gray300,
                                  ),
                                  if (currentSearch.trim().isNotEmpty) ...[
                                    const Gap(height: 10),
                                    GestureDetector(
                                      onTap: _clearSearch,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: AppColors.instance.primary,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                          child: AppText(text: "Clear Search", fontSize: 14, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        }
                        return GridView.builder(
                          itemCount: products.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final product = products[index];
                            final salePrice= product.price - (product.discount ?? 0);
                            return GestureDetector(
                              onTap: () {
                                AppRoutes.instance.pushNamed(
                                  AppRoutesKey.instance.productDetails,
                                  extra: product,
                                );
                              },
                              child: ProductContainer(
                                image: product.displayImage,
                                title: product.name,
                                subtitle: product.category?.name ?? '',
                                discountPrice: product.hasDiscount ? "\$${product.price.toStringAsFixed(0)}" : null,
                                salePrice: product.hasDiscount ? "\$${salePrice.toStringAsFixed(0)}" : "\$${product.price.toStringAsFixed(0)}",
                              ),
                            );
                          },
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.68,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                        );
                      },
                      loading: () => SizedBox(
                        height: 300,
                        child: Center(
                          child: CircularProgressIndicator(color: AppColors.instance.primary),
                        ),
                      ),
                      error: (error, stack) => SizedBox(
                        height: 200,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error_outline, size: 48, color: Colors.red),
                              const Gap(height: 10),
                              const AppText(text: "Failed to load products", fontSize: 16, color: Colors.red),
                              const Gap(height: 10),
                              GestureDetector(
                                onTap: () => ref.invalidate(productsProvider),
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
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StickyCategoryDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  _StickyCategoryDelegate({required this.child});

  @override
  double get minExtent => 86.0;
  @override
  double get maxExtent => 86.0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(_StickyCategoryDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}