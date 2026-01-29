import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/core/widgets/appbar/app_bar_widget.dart';
import 'package:meomulm_frontend/features/my_page/presentation/widgets/favorite/favorite_item_widget.dart';

class FavoriteScreen extends StatefulWidget  {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  // 테스트용 더미 데이터
  final List<Map<String, dynamic>> wishItems = [
    {
      'accommodationName': '파주 테라피크닉',
      'location': '파주시 프로방스마을',
      'imageUrls': ['https://picsum.photos/id/10/200/300','https://picsum.photos/id/10/200/300']
    },
    {
      'accommodationName': '강릉 블리스펜션',
      'location': '강릉 바다 바로 앞',
      'imageUrls': ['https://picsum.photos/id/11/200/300'],
    },
    {
      'accommodationName': '라마다 속초 호텔',
      'location': '대포항',
      'imageUrls': [],
    },
    {
      'accommodationName': '반얀트리 클럽 앤 스파',
      'location': '버티고개 1번출구',
      'imageUrls': ['https://picsum.photos/id/13/200/300'],
    },
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const AppBarWidget(title: '찜 목록'),

      body: ListView.separated(
        itemCount: wishItems.length,
        // 구분선
        separatorBuilder: (_, __) => const Divider(
          height: AppBorderWidth.md,
          color: AppColors.gray4,
        ),

        itemBuilder: (context, index) {
          final item = wishItems[index];

          return FavoriteItemWidget(
            key: ValueKey(item['accommodationName']),
            accommodationName: item['accommodationName'],
            location: item['location'],
            imageUrls: List<String>.from(item['imageUrls'] ?? []),

            onUnfavorite: () {
              setState(() {
                wishItems.removeAt(index);
              });
            },
          );
        },
      ),
    );
  }
}