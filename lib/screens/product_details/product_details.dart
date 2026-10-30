import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/constant/app_asserts_icons_path.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/models/product_model.dart';
import 'package:flutter_riverpod_template/routes/app_routes.dart';
import 'package:flutter_riverpod_template/screens/product_details/porvider/product_detail_provider.dart';
import 'package:flutter_riverpod_template/screens/product_details/porvider/select_item.dart';
import 'package:flutter_riverpod_template/utils/app_size.dart';
import 'package:flutter_riverpod_template/utils/gap.dart';
import 'package:flutter_riverpod_template/widgets/app_image/app_image.dart';
import 'package:flutter_riverpod_template/widgets/buttons/app_button.dart';
import 'package:flutter_riverpod_template/widgets/texts/app_text.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetails extends ConsumerWidget {
  final ProductModel? product;
  final String? productId;
  const ProductDetails({super.key, this.product, this.productId});

  Future<void> openWhatsApp({required String message}) async {
    final url = Uri.parse(
      "https://wa.me/252617190021?text=${Uri.encodeComponent(message)}",
    );

    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint("Could not launch WhatsApp: \$e");
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (product != null) {
      return _buildContent(context, ref, product!);
    }

    if (productId != null) {
      final productAsync = ref.watch(productDetailProvider(productId!));
      return productAsync.when(
        data: (p) {
          if (p == null) {
            return _buildNotFound(context);
          }
          return _buildContent(context, ref, p);
        },
        loading: () => Scaffold(
          backgroundColor: AppColors.instance.white50,
          body: Center(
            child: CircularProgressIndicator(color: AppColors.instance.primary),
          ),
        ),
        error: (error, stack) => _buildNotFound(context),
      );
    }

    return _buildNotFound(context);
  }

  Widget _buildNotFound(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.instance.white50,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red),
              Gap(height: 16),
              AppText(text: "Product not found", fontSize: 18, fontWeight: FontWeight.w500),
              Gap(height: 16),
              GestureDetector(
                onTap: () => AppRoutes.instance.pop(),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.instance.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: AppText(text: "Go Back", fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, ProductModel p) {
    final selectImage = ref.watch(selectItem);
    final allImages = p.images.isNotEmpty ? p.images : (p.thumbnail != null ? [p.thumbnail!] : <String>[]);
    final mainImage = selectImage < allImages.length ? allImages[selectImage] : (allImages.isNotEmpty ? allImages.first : '');
    final salePrice = p.price - (p.discount ?? 0);

    return Scaffold(
      backgroundColor: AppColors.instance.white50,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => AppRoutes.instance.pop(),
                      child: AppImage(
                        path: AppAssertsIconsPath.instance.arrowBack,
                        height: 40,
                        width: 40,
                      ),
                    ),
                    Gap(height: 20),

                    // Product image gallery
                    Stack(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: AppSize.height(value: 220),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.instance.grayContainer,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: mainImage.isNotEmpty
                                  ? AppImage(isZomBle: true, url: mainImage)
                                  : Center(child: Icon(Icons.image_not_supported, size: 48, color: AppColors.instance.gray300)),
                            ),
                          ),
                        ),
                        if (allImages.length > 1)
                          Positioned(
                            left: 10,
                            right: 10,
                            bottom: 15,
                            child: SizedBox(
                              height: 50,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: allImages.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 5,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          ref.read(selectItem.notifier).getItem(index);
                                        },
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: selectImage == index
                                                  ? AppColors.instance.primary
                                                  : Colors.transparent,
                                              width: 3,
                                            ),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(2),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(6),
                                              child: AppImage(
                                                width: 40,
                                                url: allImages[index],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),

                    Gap(height: 20),

                    // Product name
                    AppText(
                      text: p.name,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),

                    // Category
                    if (p.category != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: AppText(
                          text: p.category!.name,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.instance.gray300,
                        ),
                      ),

                    Gap(height: 10),

                    // Price
                    Row(
                      children: [
                        if (p.hasDiscount) ...[
                          AppText(
                            text: "\$${p.price.toStringAsFixed(0)}",
                            color: Colors.red,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: Colors.red,
                            fontSize: 18,
                          ),
                          Gap(width: 10),
                        ],
                        AppText(
                          text: p.hasDiscount
                              ? "\$${salePrice.toStringAsFixed(0)}"
                              : "\$${p.price.toStringAsFixed(0)}",
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                        if (p.hasDiscount && p.discountType == 'PERCENTAGE')
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                child: AppText(
                                  text: "-${p.discount!.toStringAsFixed(0)}%",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),

                    // Stock info
                    if (p.stock != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: AppText(
                          text: p.stock! > 0 ? "In Stock (${p.stock} available)" : "Out of Stock",
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: p.stock! > 0 ? AppColors.instance.success : Colors.red,
                        ),
                      ),

                    Gap(height: 10),

                    // Description
                    if (p.description != null && p.description!.isNotEmpty) ...[
                      AppText(
                        text: "Product Details",
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                      Gap(height: 10),
                      AppText(
                        text: p.description!,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ],

                    Gap(height: 10),

                    // Chat to Order button
                    AppButton(
                      onTap: () async {
                        final String orderMessage = '''
Hello Admin, I would like to order this product:

*Product Details:*
🛍️ *Name:* ${p.name}
💰 *Price:* ${p.hasDiscount ? '\$${salePrice.toStringAsFixed(0)} (was \$${p.price.toStringAsFixed(0)})' : '\$${p.price.toStringAsFixed(0)}'}
📝 *Description:* ${p.description ?? 'N/A'}

🖼️ *Product Image:*
${p.displayImage}

Please let me know the next steps for payment and delivery!
''';
                        await openWhatsApp(message: orderMessage);
                      },
                      height: 43,
                      borderRadius: BorderRadius.circular(18),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppImage(
                            path: AppAssertsIconsPath.instance.callIcon,
                            height: 30,
                          ),
                          Gap(width: 10),
                          AppText(
                            text: "Chat to Order",
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    Gap(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
