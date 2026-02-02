import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/core/widgets/appbar/app_bar_widget.dart';
import 'package:meomulm_frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:meomulm_frontend/features/my_page/data/datasources/favorite_service.dart';
import 'package:meomulm_frontend/features/my_page/data/models/select_favorite_model.dart';
import 'package:meomulm_frontend/features/my_page/presentation/widgets/favorite/favorite_item_widget.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/paths/route_paths.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<SelectFavoriteModel> selectFavorite = [];
  bool isLoading = true;

  // // 테스트용 더미 데이터
  // final List<Map<String, dynamic>> wishItems = [
  //   {
  //     'accommodationName': '파주 테라피크닉',
  //     'location': '파주시 프로방스마을',
  //     'imageUrls': ['https://picsum.photos/id/10/200/300','https://picsum.photos/id/10/200/300']
  //   },
  //   {
  //     'accommodationName': '강릉 블리스펜션',
  //     'location': '강릉 바다 바로 앞',
  //     'imageUrls': ['https://picsum.photos/id/11/200/300'],
  //   },
  //   {
  //     'accommodationName': '라마다 속초 호텔',
  //     'location': '대포항',
  //     'imageUrls': [],
  //   },
  //   {
  //     'accommodationName': '반얀트리 클럽 앤 스파',
  //     'location': '버티고개 1번출구',
  //     'imageUrls': ['https://picsum.photos/id/13/200/300'],
  //   },
  // ];

  @override
  void initState() {
    super.initState();

    final token = context
        .read<AuthProvider>()
        .token;
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
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("오류: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const AppBarWidget(title: '찜 목록'),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : selectFavorite.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 64, color: AppColors.gray3),
            SizedBox(height: 16),
            Text(
              '아직 찜한 숙소가 없습니다',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.gray2,
              ),
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

          return GestureDetector(
            onTap: () {
              // 숙소 상세 페이지로 이동
              context.push('${RoutePaths.accommodationDetail}/${item.accommodationId}');
            },
            child: FavoriteItemWidget(
              key: ValueKey(item.favoriteId),
              accommodationName: item.accommodationName,
              accommodationAddress: item.accommodationAddress,
              accommodationImageUrl: item.accommodationImageUrl ?? "",

              onUnfavorite: () async {
                final token = context
                    .read<AuthProvider>()
                    .token!;
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
