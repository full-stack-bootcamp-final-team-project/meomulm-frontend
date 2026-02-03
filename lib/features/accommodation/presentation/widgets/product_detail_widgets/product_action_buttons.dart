import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';

class ProductActionButtons extends StatelessWidget {
  final int accommodationId;
  const ProductActionButtons({super.key, required this.accommodationId});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildIconButton(Icons.favorite_border),
        const SizedBox(width: 16),
        _buildShareButton(context),
      ],
    );
  }

  // 아이콘만 있는 버튼
  Widget _buildIconButton(IconData icon) {
    return IconButton(
      onPressed: () {
        debugPrint('좋아요 클릭');
      },
      icon: Icon(icon),
      color: Colors.black, // 아이콘 색상
      iconSize: 28, // 필요하면 아이콘 크기 조절
      splashRadius: 24, // 클릭 범위
    );
  }

  Widget _buildShareButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        const String address = '서울 중구 동호로 249';

        FlutterClipboard.copy(address).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('링크가 복사되었습니다'),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.black87,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          );
        });
      },
      icon: const Icon(Icons.share),
      color: Colors.black, // 아이콘 색상
      iconSize: 28,
      splashRadius: 24,
    );
  }
}
