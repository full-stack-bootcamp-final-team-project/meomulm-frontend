import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/features/accommodation/data/models/search_accommodation_response_model.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/providers/accommodation_provider.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/screens/accommodation_detail_screen.dart';
import 'package:meomulm_frontend/features/home/presentation/providers/home_provider.dart';
import 'package:provider/provider.dart';

import 'image_none.dart';

/// 숙소 아이템
class HomeItemCard extends StatelessWidget {
  final SearchAccommodationResponseModel item;
  final double width;
  final bool isLast;

  const HomeItemCard({
    super.key,
    required this.item,
    required this.width,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final id = item.accommodationId; // 숙소 ID 가져오기
        final name = item.accommodationName;

        // Provider 업데이트
        final provider = context.read<AccommodationProvider>();
        provider.setAccommodationInfo(id, name);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AccommodationDetailScreen(accommodationId: id),
          ),
        );
      },
      child: Container(
        width: width,
        margin: EdgeInsets.only(right: isLast ? 0 : AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 3 / 4,
              child:
                  (item.accommodationImages != null &&
                      item.accommodationImages!.isNotEmpty)
                  ? Image.network(
                      item.accommodationImages!.first.accommodationImageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => ImageNone(),
                    )
                  : ImageNone(),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              item.accommodationName,
              style: AppTextStyles.subTitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '${item.minPrice}원 ~',
              style: AppTextStyles.subTitle.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
