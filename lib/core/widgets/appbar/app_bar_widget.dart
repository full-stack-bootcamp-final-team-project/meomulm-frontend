import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  static const double _appBarHeight = 70;
  static const double _dividerHeight = 1;

  const AppBarWidget({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      centerTitle: true,


      toolbarHeight: _appBarHeight - _dividerHeight,

      leading: IconButton(
        icon: const Icon(AppIcons.back),
        onPressed: () => Navigator.of(context).maybePop(),
      ),

      title: Text(
        title,
        style: AppTextStyles.appBarTitle,
      ),

      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(_dividerHeight),
        child: Divider(
          height: _dividerHeight,
          thickness: _dividerHeight,
          color: AppColors.gray3,
        ),
      ),
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(_appBarHeight);
}
