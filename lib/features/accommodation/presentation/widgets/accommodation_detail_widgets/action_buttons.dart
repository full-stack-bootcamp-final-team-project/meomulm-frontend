import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/features/accommodation/data/datasources/favorite_api_service.dart';
import 'package:meomulm_frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:meomulm_frontend/core/constants/paths/route_paths.dart' as AppRouter;

class ActionButtons extends StatefulWidget {
  final int accommodationId;
  const ActionButtons({super.key, required this.accommodationId});

  @override
  State<ActionButtons> createState() => _ActionButtonsState();
}

class _ActionButtonsState extends State<ActionButtons> {
  bool isFavorite = false;
  int favoriteId = 0; // 서버에서 받아올 찜 식별 번호
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  // 초기 찜 상태 로드
  Future<void> _loadFavoriteStatus() async {
    final token = context.read<AuthProvider>().token;
    if (token == null || widget.accommodationId <= 0) return;

    try {
      final backFavoriteId = await FavoriteApiService.getFavorite(
        token,
        widget.accommodationId,
      );

      if (mounted) {
        setState(() {
          favoriteId = backFavoriteId;
          isFavorite = backFavoriteId > 0;
        });
      }
    } catch (e) {
      debugPrint('찜 상태 로드 실패: $e');
    }
  }

  // 찜 토글 로직
  Future<void> _toggleFavorite() async {
    final token = context.read<AuthProvider>().token;

    // 로그인 체크
    if (token == null) {
      context.go(AppRouter.RoutePaths.login);
      return;
    }

    if (isLoading) return;

    setState(() => isLoading = true);

    try {
      if (!isFavorite) {
        // 1. 찜 추가
        await FavoriteApiService.postFavorite(token, widget.accommodationId);
        debugPrint('찜 추가 완료');
      } else {
        // 2. 찜 삭제 (저장된 favoriteId 사용)
        if (favoriteId > 0) {
          await FavoriteApiService.deleteFavorite(token, favoriteId);
          debugPrint('찜 삭제 완료');
        }
      }
    } catch (e) {
      debugPrint('찜 변경 실패: $e');
    } finally {
      // 3. 상태 재로드하여 favoriteId와 하트 상태 동기화
      await _loadFavoriteStatus();
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildCircleButton(
          icon: isFavorite ? Icons.favorite : Icons.favorite_border,
          iconColor: isFavorite ? Colors.red : Colors.white,
          onTap: _toggleFavorite,
          showLoader: isLoading,
        ),
        const SizedBox(width: 16),
        _buildCircleButton(
          icon: Icons.share,
          iconColor: Colors.white,
          onTap: () => _copyLink(context),
        ),
      ],
    );
  }

  // 슬라이더 디자인에 맞춘 원형 버튼 위젯
  Widget _buildCircleButton({
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
    bool showLoader = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7), // 기존 디자인 유지
          shape: BoxShape.circle,
        ),
        child: showLoader
            ? const Padding(
          padding: EdgeInsets.all(10.0),
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
        )
            : Icon(icon, color: iconColor, size: 22),
      ),
    );
  }

  void _copyLink(BuildContext context) {
    const String address = '서울 중구 동호로 249'; // 필요시 숙소 주소나 링크로 변경
    FlutterClipboard.copy(address).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('링크가 복사되었습니다'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    });
  }
}