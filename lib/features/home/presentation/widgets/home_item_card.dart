import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/screens/accommodation_detail_screen.dart';

import 'image_none.dart';

/// 숙소 아이템
class HomeItemCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final double width;
  final bool isLast;

  const HomeItemCard({super.key, required this.item, required this.width, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final id = item['id']; // 숙소 ID 가져오기
        if (id != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AccommodationDetailScreen(accommodationId: id),
            ),
          );
        }
      },
      child: Container(
        width: width,
        margin: EdgeInsets.only(right: isLast ? 0 : AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 3 / 4,
              child: item['img'] != null && item['img']!.isNotEmpty
              ? Image.network(
                item['img']!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // 이미지 로드 실패 시 대체 UI
                  return ImageNone();
                },
              )
              : ImageNone(),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(item['title']!, style: AppTextStyles.subTitle, maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: AppSpacing.sm),
            Text(item['price']!, style: AppTextStyles.subTitle.copyWith(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}