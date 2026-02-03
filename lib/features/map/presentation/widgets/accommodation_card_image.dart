import 'package:flutter/material.dart';

/// 숙소 카드의 이미지 섹션
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
    final isNetworkImage = imageUrl.startsWith('http');

    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
          child: SizedBox(
            height: 180,
            width: double.infinity,
            child: isNetworkImage
                ? _buildNetworkImage()
                : _buildAssetImage(),
          ),
        ),

        // 닫기 버튼
        if (onClose != null)
          Positioned(
            top: 8,
            right: 8,
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
        // 에러 시 기본 이미지 표시
        final imageIndex = (accommodationId % 3) + 1;
        return Image.asset(
          'assets/images/accommodation/default_accommodation_image($imageIndex).jpg',
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
    );
  }

  /// 에셋 이미지 위젯
  Widget _buildAssetImage() {
    return Image.asset(
      imageUrl,
      fit: BoxFit.cover,
    );
  }

  /// 닫기 버튼
  Widget _buildCloseButton() {
    return GestureDetector(
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
    );
  }
}