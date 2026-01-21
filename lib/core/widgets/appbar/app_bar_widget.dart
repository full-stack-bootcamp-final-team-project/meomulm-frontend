import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;

  const AppBarWidget({super.key, required this.title, this.onBack});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      centerTitle: true,

      toolbarHeight: AppBarDimensions.appBarHeight - AppBarDimensions.dividerHeight,

      leading: IconButton(
        icon: const Icon(AppIcons.back),
        onPressed: onBack ?? () => Navigator.of(context).maybePop(),
      ),

      title: Text(title, style: AppTextStyles.appBarTitle),

      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(AppBarDimensions.dividerHeight),
        child: Divider(
          height: AppBarDimensions.dividerHeight,
          thickness: AppBarDimensions.dividerHeight,
          color: AppColors.gray3,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(AppBarDimensions.appBarHeight);
}
