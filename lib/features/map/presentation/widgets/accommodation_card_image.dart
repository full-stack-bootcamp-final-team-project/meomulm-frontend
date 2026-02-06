import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/core/utils/accommodation_image_utils.dart';

/// 숙소 카드의 이미지 섹션 위젯
class AccommodationCardImage extends StatelessWidget {
  final String imageUrl;
  final int accommodationId;
  final VoidCallback? onClose;

  const AccommodationCardImage({
    super.key,
    required this.imageUrl,
    required this.accommodationId,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(AppBorderRadius.lg),
            topRight: Radius.circular(AppBorderRadius.lg),
          ),
          child: SizedBox(
            height: 180,
            width: double.infinity,
            child: AccommodationImageUtils.isNetworkImage(imageUrl)
                ? _buildNetworkImage()
                : _buildAssetImage(),
          ),
        ),

        if (onClose != null)
          Positioned(
            top: AppSpacing.sm,
            right: AppSpacing.sm,
            child: _buildCloseButton(),
          ),
      ],
    );
  }

  /// 네트워크 이미지 위젯
  Widget _buildNetworkImage() {
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          AccommodationImageUtils.getDefaultImagePath(accommodationId),
          fit: BoxFit.cover,
        );
      },
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(color: AppColors.gray5);
      },
    );
  }

  /// 에셋 이미지 위젯
  Widget _buildAssetImage() {
    return Image.asset(imageUrl, fit: BoxFit.cover);
  }

  /// 닫기 버튼
  Widget _buildCloseButton() {
    return Material(
      color: AppColors.black.withValues(alpha: 0.5),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onClose,
        customBorder: const CircleBorder(),
        child: const Padding(
          padding: EdgeInsets.all(AppSpacing.sm),
          child: Icon(
            AppIcons.close,
            size: AppIcons.sizeMd,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}
