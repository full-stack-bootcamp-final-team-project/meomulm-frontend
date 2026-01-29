import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';

/// 숙소 아이템
class HomeItemCard extends StatelessWidget {
  final Map<String, String> item;
  final double width;
  final bool isLast;

  const HomeItemCard({super.key, required this.item, required this.width, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: EdgeInsets.only(right: isLast ? 0 : AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 3 / 4,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppBorderRadius.xs),
                image: DecorationImage(
                  image: NetworkImage(item['img']!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(item['title']!, style: AppTextStyles.subTitle, maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: AppSpacing.sm),
          Text(item['price']!, style: AppTextStyles.subTitle.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}