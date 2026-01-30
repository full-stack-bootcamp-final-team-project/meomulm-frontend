import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/features/accommodation/data/models/search_accommodation_response_model.dart';
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
        // ========== 데이터 로드 완료 후 최근 본 숙소 저장 ==========
        final recentItem = item;
        print('item.accommodationLatitude $item.accommodationLatitude');
        print("item.accommodationLongitude $item.accommodationLongitude");
        print(item.categoryCode);
        print(item.accommodationAddress);
        print(item.accommodationId);
        print(item.accommodationName);
        print(item.accommodationImages);
        print(item.minPrice);
        final homeProvider = context.read<HomeProvider>();

        if (recentItem.accommodationId != null) {
          await homeProvider.addRecentAccommodation(recentItem).then((_) {
            debugPrint("숙소 저장 완료");
          });
        }
        // =========================================================
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
