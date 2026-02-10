import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:go_router/go_router.dart';

/// 탭 영역(홈에서만 노출)
class BottomNavBarWidget extends StatelessWidget {
  final VoidCallback onHomeTap;

  const BottomNavBarWidget({super.key, required this.onHomeTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(color: AppColors.white, boxShadow: AppShadows.bottomNav),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navIcon(context, AppIcons.home, RoutePaths.home, color: AppColors.main),
          _navIcon(context, AppIcons.search, RoutePaths.accommodationSearch),
          _navIcon(context, AppIcons.map, RoutePaths.map),
          _navIcon(context, AppIcons.favorite, '${RoutePaths.myPage}${RoutePaths.favorite}'),
          _navIcon(context, AppIcons.person, RoutePaths.myPage),
        ],
      ),
    );
  }

  Widget _navIcon(BuildContext context, IconData icon, String page, {Color color = AppColors.black}) {
    return GestureDetector(
      onTap: () {
        if (page == RoutePaths.home) {
          onHomeTap();
        } else {
          context.push(page);
        }
      },
      child: Icon(icon, size: AppIcons.sizeXxl, color: color),
    );
  }
}