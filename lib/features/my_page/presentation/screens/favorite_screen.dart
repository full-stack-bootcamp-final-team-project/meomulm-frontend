import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/core/utils/accommodation_image_utils.dart';
import 'package:meomulm_frontend/core/widgets/appbar/app_bar_widget.dart';
import 'package:meomulm_frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:meomulm_frontend/features/my_page/data/datasources/favorite_service.dart';
import 'package:meomulm_frontend/features/my_page/data/models/select_favorite_model.dart';
import 'package:meomulm_frontend/features/my_page/presentation/widgets/favorite/favorite_item_widget.dart';
import 'package:provider/provider.dart';


class FavoriteScreen extends StatefulWidget  {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<SelectFavoriteModel> selectFavorite = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    final token = context.read<AuthProvider>().token;
    loadFavorite(token!);
  }

  Future<void> loadFavorite(String token) async {
    setState(() => isLoading = true);
    try {
      final favoriteService = FavoriteService();
      final result = await favoriteService.getFavorites(token);
      setState(() {
        selectFavorite = result;
        isLoading = false;
      });
    } catch(e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text("오류: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const AppBarWidget(title: TitleLabels.wishlist),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : selectFavorite.isEmpty // 숙소가 없을 경우
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(AppIcons.favorite, size: AppIcons.sizeXxl, color: AppColors.gray3),
            SizedBox(height: AppSpacing.lg),
            Text(
              '아직 찜한 숙소가 없습니다',
              style: AppTextStyles.bodySm.copyWith(color: AppColors.gray2),
            ),
          ],
        ),
      )
      : ListView.separated(
        itemCount: selectFavorite.length,
        // 구분선
        separatorBuilder: (_, __) =>
        const Divider(
          height: AppBorderWidth.md,
          color: AppColors.gray4,
        ),

        itemBuilder: (context, index) {
          final item = selectFavorite[index];
          final imageUrl = AccommodationImageUtils.getImageUrlFromFavorite(item);


          return GestureDetector(
            onTap: () {
              // 숙소 상세 페이지로 이동
              context.push('${RoutePaths.accommodationDetail}/${item.accommodationId}');
            },
            child: FavoriteItemWidget(
              key: ValueKey(item.favoriteId),
              accommodationName: item.accommodationName,
              accommodationAddress: item.accommodationAddress,
                accommodationImageUrl: imageUrl,

              onUnfavorite: () async {
                final token = context.read<AuthProvider>().token!;
                final favoriteService = FavoriteService();

                final success = await favoriteService.deleteFavorite(
                  token,
                  item.favoriteId,
                );
                if (success) {
                  setState(() {
                    selectFavorite.removeAt(index);
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('찜 삭제에 실패했습니다')),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}