import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/theme/app_colors.dart';
import 'package:meomulm_frontend/core/theme/app_dimensions.dart';
import 'package:meomulm_frontend/core/theme/app_icons.dart';
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

  Future<void> _toggleFavorite() async {
    final token = context.read<AuthProvider>().token;

    if (token == null) {
      context.go(AppRouter.RoutePaths.login);
      return;
    }

    if (isLoading) return;

    setState(() => isLoading = true);

    try {
      if (!isFavorite) {
        await FavoriteApiService.postFavorite(token, widget.accommodationId);
        debugPrint('찜 추가 완료');
      } else {
        if (favoriteId > 0) {
          await FavoriteApiService.deleteFavorite(token, favoriteId);
          debugPrint('찜 삭제 완료');
        }
      }
    } catch (e) {
      debugPrint('찜 변경 실패: $e');
    } finally {
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
          icon: isFavorite ? AppIcons.favoriteFilled : AppIcons.favoriteRounded,
          iconColor: isFavorite ? AppColors.cancelled : AppColors.white,
          onTap: _toggleFavorite,
          showLoader: isLoading,
        ),
        const SizedBox(width: AppSpacing.lg),
        _buildCircleButton(
          icon: Icons.share,
          iconColor: AppColors.white,
          onTap: () => _copyLink(context),
        ),
      ],
    );
  }

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
          color: AppColors.black,
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
            backgroundColor: AppColors.black,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      }
    });
  }
}

