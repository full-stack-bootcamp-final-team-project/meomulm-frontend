import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/constants/paths/api_paths.dart';
import 'package:meomulm_frontend/core/constants/paths/route_paths.dart' as AppRouter;
import 'package:meomulm_frontend/features/my_page/presentation/providers/user_profile_provider.dart';
import 'package:provider/provider.dart';

import '../../../../auth/presentation/providers/auth_provider.dart';
import '../../../data/datasources/favorite_api_service.dart';

class ProductActionButtons extends StatefulWidget {
  final int accommodationId;
  const ProductActionButtons({super.key, required this.accommodationId});

  @override
  State<ProductActionButtons> createState() => _ProductActionButtonsState();
}

class _ProductActionButtonsState extends State<ProductActionButtons> {
  bool isFavorite = false;
  bool isLoadingFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadFavorite();
  }

  int favoriteId = 0;

  // 페이지 열리자마자 찜 상태 로드
  Future<void> _loadFavorite() async {
    final token = context.read<AuthProvider>().token;
    if (token == null) return;

    setState(() {
      isLoadingFavorite = true;
    });

    try {
      final backFavoriteId = await FavoriteApiService.getFavorite(
        token,
        widget.accommodationId,
      );

      setState(() {
        // favoriteId가 0이면 false, 1 이상이면 true
        isFavorite = backFavoriteId > 0;
        isLoadingFavorite = false;
        favoriteId = backFavoriteId;
      });

      debugPrint('찜 여부: $backFavoriteId');
    } catch (e) {
      debugPrint('찜 상태 로드 실패: $e');
      setState(() {
        isFavorite = false;
        isLoadingFavorite = false;
      });
    }
  }



  // 좋아요 버튼 클릭
  Future<void> _toggleFavorite() async {
    final token = context.read<AuthProvider>().token;

    if (token == null) {
      // token 없으면 로그인 화면으로 이동 또는 UserProfile 로드
      Future.microtask(() {
        final token = context.read<AuthProvider>().token;
        if (token != null) {
          context.read<UserProfileProvider>().loadUserProfile(token);
        } else {
          context.go(AppRouter.RoutePaths.login);
        }
      });
      return;
    }

    if (isLoadingFavorite) return; // 로딩 중이면 클릭 방지

    setState(() {
      isLoadingFavorite = true;
    });

    try {
      if (!isFavorite) {
        await FavoriteApiService.postFavorite(token, widget.accommodationId);
        setState(() {
          isFavorite = true;
        });
        debugPrint('찜 추가 완료');
      } else {
        await FavoriteApiService.deleteFavorite(token, favoriteId);
        setState(() => isFavorite = false);
      }
    } catch (e) {
      debugPrint('찜 상태 변경 실패: $e');
    } finally {
      setState(() {
        isLoadingFavorite = false;
      });
      _loadFavorite();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildIconButton(),
        const SizedBox(width: 16),
        _buildShareButton(context),
      ],
    );
  }

  // 좋아요 버튼
  Widget _buildIconButton() {
    return IconButton(
      onPressed: _toggleFavorite,
      icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
      color: Colors.red,
      iconSize: 28,
      splashRadius: 24,
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
      color: Colors.black,
      iconSize: 28,
      splashRadius: 24,
    );
  }
}
