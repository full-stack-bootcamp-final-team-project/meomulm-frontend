import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';
import 'package:provider/provider.dart';

import '../../../../auth/presentation/providers/auth_provider.dart';
import '../../../../my_page/data/datasources/favorite_service.dart';

//class ActionButtons extends StatelessWidget {
class ActionButtons extends StatefulWidget {
  final int accommodationId;
  const ActionButtons({super.key, required this.accommodationId});
  //**************** add code ****************
  @override
  State<ActionButtons> createState() => _ActionButtonsState();
}

class _ActionButtonsState extends State<ActionButtons> {
  bool isFavorite = false;
  bool isLoading = false;
  //**************** add code ****************
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildFavoriteButton(context),
        const SizedBox(width: 16),
        _buildShareButton(context),
        /*
        _buildIconButton(Icons.favorite_border),
        const SizedBox(width: 16),
        _buildShareButton(context), // 공유 버튼만 분리

         */
      ],
    );
  }
  Widget _buildFavoriteButton(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : () => _toggleFavorite(context),
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
        child: isLoading
            ? Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
            : Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: isFavorite ? Colors.red : Colors.white,
          size: 22,
        ),
      ),
    );
  }

  Future<void> _toggleFavorite(BuildContext context) async {
    final token = context.read<AuthProvider>().token;
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인이 필요합니다')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final favoriteService = FavoriteService();

      // 찜 추가
      final success = await favoriteService.postFavorite(token, widget.accommodationId);

      if (success) {
        setState(() {
          isFavorite = true;
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('찜 목록에 추가되었습니다'),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.black87,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      } else {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('찜 추가에 실패했습니다')),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오류가 발생했습니다: $e')),
      );
    }
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