import 'package:flutter/material.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/utils/app_size.dart';
import 'package:flutter_riverpod_template/utils/gap.dart';
import 'package:flutter_riverpod_template/widgets/app_image/app_image.dart';
import 'package:flutter_riverpod_template/widgets/texts/app_text.dart';

class ProductContainer extends StatelessWidget {
  final String title;
  final String image;
  final String subtitle;
  final String? discountPrice;
  final String salePrice;

  const ProductContainer({
    super.key,
    required this.title,
    this.discountPrice,
    required this.salePrice,
    required this.subtitle,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.instance.white50,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.instance.white50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: AppImage(
                  width: double.infinity,
                  height: 110,
                  url: image,
                ),
              ),
              Gap(height: 5),
              AppText(
                text: title,
                fontSize: AppSize.width(value: 16),
                fontWeight: FontWeight.w600,
                color: Colors.black,
                maxLines: 2,
              ),
              AppText(
                text: subtitle,
                fontSize: AppSize.width(value: 12),
                fontWeight: FontWeight.w400,
                color: Colors.black,
                maxLines: 1,
              ),
              Gap(height: 5),
              Row(
                children: [
                  AppText(
                    text: "Price:",
                    fontSize: AppSize.width(value: 16),
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  SizedBox(width: 5),
                  AppText(
                    text: "${discountPrice ?? ''} ",
                    fontSize: AppSize.width(value: 14),
                    fontWeight: FontWeight.w400,
                    color: Colors.red,
                    decorationColor: Colors.red,
                    decoration: TextDecoration.lineThrough,
                  ),
                  Gap(width: 5),
                  Expanded(
                    child: AppText(
                      text: salePrice,
                      fontSize: AppSize.width(value: 16),
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
