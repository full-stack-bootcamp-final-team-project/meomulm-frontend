import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';

class ActionButtons extends StatelessWidget {
  final int accommodationId;
  const ActionButtons({super.key, required this.accommodationId});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildIconButton(Icons.favorite_border),
        const SizedBox(width: 16),
        _buildShareButton(context), // 공유 버튼만 분리
      ],
    );
  }

  Widget _buildIconButton(IconData icon) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: 22),
    );
  }

  Widget _buildShareButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 복사할 주소 (원하는 텍스트로 자유롭게 변경 가능)
        // const String address = 'http://localhost:8080/accommodation/result/$accommodationId';
        const String address = '서울 중구 동호로 249';

        FlutterClipboard.copy(address).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('링크가 복사되었습니다'),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.black87,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          );
        });
      },
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.grey[900],
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(Icons.share, color: Colors.white, size: 22),
      ),
    );
  }
}