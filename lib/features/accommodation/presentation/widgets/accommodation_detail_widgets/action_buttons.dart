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

  /// deeplink URL 생성
  /// 예: https://meomulm.app/accommodation-detail/42
  static String _buildDeepLink(int id) {
    // TODO: 프로덕션 배포 시 아래 URL을 실제 도메인으로 교체
    // 예: https://meomulm.app/accommodation-detail/$id
    // 개발 단계에서는 커스탬 스키마 형태로도 사용 가능:
    //   meomulm://accommodation-detail/$id
    //
    // ▸ HTTPS Universal Link / App Link 방식 (권장)
    //   → assetlinks.json 및 apple-app-site-association 파일 배포 필요
    // ▸ Custom Scheme 방식 (빠르게 테스트하기 좋음)
    //   → AndroidManifest intent-filter 및 Flutter app 등록 필요
    //
    // 아래는 Custom Scheme 기준 구현. HTTPS로 전환하면 URL만 바꾸면 됨.
    return 'meomulm://accommodation-detail/$id';
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
    final deepLink = _buildDeepLink(widget.accommodationId);

    FlutterClipboard.copy(deepLink).then((_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('링크가 복사되었습니다'),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.black87,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      }
    });
  }
}

