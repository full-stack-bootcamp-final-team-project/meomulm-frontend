import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/constants/paths/route_paths.dart';
import 'package:meomulm_frontend/core/utils/price_formatter.dart';

/// 숙소 카드의 정보 섹션
class AccommodationCardInfo extends StatelessWidget {
  final int accommodationId;
  final String name;
  final String address;
  final int minPrice;

  const AccommodationCardInfo({
    super.key,
    required this.accommodationId,
    required this.name,
    required this.address,
    required this.minPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 숙소 이름
          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),

          // 주소
          _buildAddressRow(),
          const SizedBox(height: 8),

          // 가격
          _buildPriceText(),
          const SizedBox(height: 12),

          // 상세정보 버튼
          _buildDetailButton(context),
        ],
      ),
    );
  }

  /// 주소 표시 위젯
  Widget _buildAddressRow() {
    return Row(
      children: [
        Icon(
          Icons.location_on_outlined,
          size: 16,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            address,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// 가격 표시 위젯
  Widget _buildPriceText() {
    return Text(
      '${minPrice.formatPrice()}원~',
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: Colors.blue,
      ),
    );
  }

  /// 상세정보 버튼
  Widget _buildDetailButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          context.push(
            '${RoutePaths.accommodationDetail}/$accommodationId',
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
    );
  }
}