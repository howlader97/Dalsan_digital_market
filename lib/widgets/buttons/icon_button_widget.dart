import 'package:flutter/material.dart';

import '../../constant/app_colors.dart';
import '../../utils/app_size.dart';

class IconButtonWidget extends StatelessWidget {
  final double? padding;
  final VoidCallback? onTap;
  final IconData icon;
  const IconButtonWidget({
    super.key,
    this.padding,
    this.onTap, required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final double defaultPadding =AppSize.size.width * 0.02;
    return GestureDetector(
      onTap:onTap ,
      child: Container(
        padding: EdgeInsets.all(padding ?? defaultPadding) ,
        decoration: BoxDecoration(
          color: AppColors.instance.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        child:  Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}