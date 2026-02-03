import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/utils/accommodation_image_utils.dart';
import 'package:meomulm_frontend/features/accommodation/data/models/search_accommodation_response_model.dart';
import 'package:meomulm_frontend/features/map/presentation/widgets/accommodation_card_image.dart';
import 'package:meomulm_frontend/features/map/presentation/widgets/accommodation_card_info.dart';

/// 지도에서 선택된 숙소를 표시하는 카드
class MapAccommodationCard extends StatelessWidget {
  final SearchAccommodationResponseModel accommodation;
  final VoidCallback? onClose;

  const MapAccommodationCard({
    super.key,
    required this.accommodation,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    // StatefulWidget 대신 StatelessWidget으로 변경
    // accommodation이 변경될 때마다 새로운 위젯이 생성되어 이미지도 업데이트됨
    final imageUrl = AccommodationImageUtils.getImageUrl(accommodation);

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(
        maxHeight: 400,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 이미지 섹션
          AccommodationCardImage(
            key: ValueKey(accommodation.accommodationId), // key 추가로 강제 리빌드
            imageUrl: imageUrl,
            accommodationId: accommodation.accommodationId,
            onClose: onClose,
          ),

          // 정보 섹션
          AccommodationCardInfo(
            accommodationId: accommodation.accommodationId,
            name: accommodation.accommodationName,
            address: accommodation.accommodationAddress,
            minPrice: accommodation.minPrice,
          ),
        ],
      ),
    );
  }
}