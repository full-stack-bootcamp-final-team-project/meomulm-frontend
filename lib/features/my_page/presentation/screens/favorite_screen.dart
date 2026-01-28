import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/core/widgets/appbar/app_bar_widget.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 테스트용 더미 데이터
    final List<Map<String, String>> wishItems = [
      {
        'title': '파주 테라피크닉',
        'location': '파주시 프로방스마을',
        'imageUrl': 'https://picsum.photos/id/10/200/300',
      },
      {
        'title': '강릉 블리스펜션',
        'location': '강릉 바다 바로 앞',
        'imageUrl': 'https://picsum.photos/id/11/200/300',
      },
      {
        'title': '라마다 속초 호텔',
        'location': '대포항',
        'imageUrl': '',
      },
      {
        'title': '반얀트리 클럽 앤 스파',
        'location': '버티고개 1번출구',
        'imageUrl': 'https://picsum.photos/id/13/200/300',
      },
    ];

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
            title: item['title']!,
            location: item['location']!,
            imageUrl: item['imageUrl']!,
          );
        },
      ),
    );
  }
}

/// ========================== FavoriteItemWidget ==========================
class FavoriteItemWidget extends StatelessWidget {
  // 숙소명
  final String title;
  // 숙소 주소
  final String location;

  // 숙소 이미지
  final String imageUrl;

  const FavoriteItemWidget({
    super.key,
    required this.title,
    required this.location,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FavoriteImage(imageUrl: imageUrl),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: FavoriteInfo(title: title, location: location)),
          const FavoriteHeartIcon(),
        ],
      ),
    );
  }
}

/// ========================== FavoriteImage ==========================
class FavoriteImage extends StatelessWidget {
  final String imageUrl;

  const FavoriteImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppBorderRadius.md),
      child: Image.network(
        imageUrl,
        width: 100,
        height: 140,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: 100,
            height: 140,
            color: AppColors.gray5,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(strokeWidth: 2),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 100,
            height: 140,
            color: AppColors.gray5,
            alignment: Alignment.center,
            child: Icon(
              Icons.image,
              color: AppColors.gray3,
              size: AppIcons.sizeXxl,
            ),
          );
        },
      ),
    );
  }
}

/// ========================== FavoriteInfo ==========================
class FavoriteInfo extends StatelessWidget {
  final String title;
  final String location;

  const FavoriteInfo({super.key, required this.title, required this.location});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.xs),
        Text(title, style: AppTextStyles.cardTitle),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          location,
          style: AppTextStyles.bodySm.copyWith(fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}

/// ========================== FavoriteHeartIcon ==========================
class FavoriteHeartIcon extends StatelessWidget {
  const FavoriteHeartIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppIcons.sizeXxl,
      height: AppIcons.sizeXxl,
      decoration: BoxDecoration(
        color: AppColors.gray5,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.favorite,
        color: Colors.red,
        size: AppIcons.sizeMd,
      ),
    );
  }
}
