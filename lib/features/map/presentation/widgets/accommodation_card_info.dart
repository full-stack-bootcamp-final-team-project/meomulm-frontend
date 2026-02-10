import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/constants/paths/route_paths.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/core/utils/price_formatter.dart';
import 'package:meomulm_frontend/core/widgets/buttons/button_widgets.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/providers/accommodation_provider.dart';
import 'package:provider/provider.dart';

/// 숙소 카드의 정보 섹션 위젯
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
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: AppTextStyles.bodyXl,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.xs),

          // 주소
          _buildAddressRow(),
          const SizedBox(height: AppSpacing.sm),

          // 가격
          _buildPriceText(),
          const SizedBox(height: AppSpacing.md),

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
        Icon(AppIcons.locationOnOutline, size: AppIcons.sizeSm),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            address,
            style: AppTextStyles.bodySm,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// 가격 표시 위젯
  Widget _buildPriceText() {
    return Text('${minPrice.formatPrice()}원~', style: AppTextStyles.bodyXl);
  }

  /// 상세정보 버튼
  Widget _buildDetailButton(BuildContext context) {
    return SmallButton(
      label: '상세정보 보기',
      enabled: true,
      onPressed: () {
        context.read<AccommodationProvider>().setAccommodationInfo(
          accommodationId,
          name,
        );
        context.push('${RoutePaths.accommodationDetail}/$accommodationId');
      },
    );
  }

}
