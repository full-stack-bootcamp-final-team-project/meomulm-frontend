import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/core/utils/accommodation_image_utils.dart';
import 'package:meomulm_frontend/features/accommodation/data/models/search_accommodation_response_model.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/providers/accommodation_provider.dart';
import 'package:provider/provider.dart';

import 'image_none.dart';

/// 숙소 아이템
class HomeItemCard extends StatelessWidget {
  final SearchAccommodationResponseModel item;
  final double width;
  final bool isLast;

  HomeItemCard({
    super.key,
    required this.item,
    required this.width,
    this.isLast = false,
  });

  // 가격 포맷 (콤마)
  final priceFormat = NumberFormat('#,###');

  @override
  Widget build(BuildContext context) {
    final imageUrl = AccommodationImageUtils.getImageUrl(item);

    return GestureDetector(
      onTap: () {
        final id = item.accommodationId; // 숙소 ID 가져오기
        final name = item.accommodationName;

        // Provider 업데이트
        final provider = context.read<AccommodationProvider>();
        provider.setAccommodationInfo(id, name);
        context.push('${RoutePaths.accommodationDetail}/$id');
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
                AccommodationImageUtils.isNetworkImage(imageUrl)
                    ? Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => ImageNone(),
                )
                    : Image.asset(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
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
              '${priceFormat.format(item.minPrice)}원 ~',
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
