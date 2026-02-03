import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/constants/paths/route_paths.dart';
import 'package:meomulm_frontend/features/accommodation/data/models/search_accommodation_response_model.dart';

class MapAccommodationCard extends StatelessWidget {
  final SearchAccommodationResponseModel accommodation;
  final VoidCallback onTap;
  final VoidCallback? onClose;

  const MapAccommodationCard({
    super.key,
    required this.accommodation,
    required this.onTap,
    this.onClose,
  });

  // 첫 번째 이미지 URL 가져오기 또는 기본 이미지
  String get _imageUrl {
    if (accommodation.accommodationImages != null &&
        accommodation.accommodationImages!.isNotEmpty) {
      return accommodation.accommodationImages!.first.accommodationImageUrl;
    }
    // 이미지가 없으면 1~3 중 랜덤으로 기본 이미지 선택
    final randomIndex = Random().nextInt(3) + 1;
    return 'assets/images/default_accommodation_image($randomIndex).jpg';
  }

  @override
  Widget build(BuildContext context) {
    final isNetworkImage = _imageUrl.startsWith('http');

    return Container(
      width: double.infinity,
      // 최대 높이 제한 추가
      constraints: const BoxConstraints(
        maxHeight: 400, // 카드 최대 높이
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
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: SizedBox(
                  height: 180, // 이미지 고정 높이 설정
                  width: double.infinity,
                  child: isNetworkImage
                      ? Image.network(
                    _imageUrl,
                    fit: BoxFit.cover, // cover로 이미지가 짤리지 않고 꽉 채움
                    errorBuilder: (context, error, stackTrace) {
                      final randomIndex = Random().nextInt(3) + 1;
                      return Image.asset(
                        'assets/images/default_accommodation_image($randomIndex).jpg',
                        fit: BoxFit.cover,
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                  )
                      : Image.asset(
                    _imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              if (onClose != null)
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: onClose,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          // 숙소 정보
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 숙소 이름
                Text(
                  accommodation.accommodationName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),

                // 주소
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        accommodation.accommodationAddress,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // 가격
                Text(
                  '${_formatPrice(accommodation.minPrice)}원~',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 12),

                // 상세정보 버튼
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.push(
                        '${RoutePaths.accommodationDetail}/${accommodation.accommodationId}',
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      '상세정보 보기',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 가격 포맷팅 (천 단위 콤마)
  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
    );
  }
}