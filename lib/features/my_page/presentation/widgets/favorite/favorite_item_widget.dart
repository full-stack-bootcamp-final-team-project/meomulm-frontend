import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/features/my_page/presentation/widgets/favorite/favorite_heart_icon_widget.dart';
import 'package:meomulm_frontend/features/my_page/presentation/widgets/favorite/favorite_image_widget.dart';
import 'package:meomulm_frontend/features/my_page/presentation/widgets/favorite/favorite_info_widget.dart';

class FavoriteItemWidget extends StatefulWidget {
  // 숙소명
  final String accommodationName;

  // 숙소 주소
  final String accommodationAddress;

  // 숙소 이미지, 첫 번째 이미지만
  final String accommodationImageUrl;

  // 찜 해제 콜백 (부모에서 주입)
  final VoidCallback onUnfavorite;

  const FavoriteItemWidget({
    super.key,
    required this.accommodationName,
    required this.accommodationAddress,
    required this.accommodationImageUrl,
    required this.onUnfavorite,
  });

  @override
  State<FavoriteItemWidget> createState() => _FavoriteItemWidgetState();
}

class _FavoriteItemWidgetState extends State<FavoriteItemWidget> {
  @override
  Widget build(BuildContext context) {
    // // 대표 이미지
    // final String? thumbnailImage =
    // widget.accommodationImageUrl.isNotEmpty ? widget.accommodationImageUrl : null;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 숙소 이미지
          FavoriteImage(imageUrl: widget.accommodationImageUrl),
          const SizedBox(width: AppSpacing.md),

          // 숙소 정보 영역 (제목 + 위치)
          Expanded(child: FavoriteInfo(accommodationName: widget.accommodationName, location: widget.accommodationAddress)),

          // 찜 아이콘
          FavoriteHeartIcon (
            onUnfavorite: () {
              _showUnfavoriteDialog(context);
            },
          ),
        ],
      ),
    );
  }

  /// 찜 해제 확인 다이얼로그
  void _showUnfavoriteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('찜 해제'),
        content: const Text('찜 목록에서 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);

              widget.onUnfavorite();


              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('찜 목록에서 삭제되었습니다.'),
                  duration: Duration(seconds: 2),
                ),
              );

              debugPrint('찜 삭제됨: ${widget.accommodationName}');
            },
            child: const Text(
              '삭제',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
