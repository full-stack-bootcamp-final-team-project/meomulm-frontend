import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/core/utils/date_people_utils.dart';

class SearchBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String? keyword;
  final String? dateText;
  final int peopleCount;
  final VoidCallback? onBack;
  final VoidCallback? onClear;
  final VoidCallback? onSearch;
  final VoidCallback? onFilter;

  const SearchBarWidget({
    super.key,
    this.keyword,
    this.dateText,
    required this.peopleCount,
    this.onBack,
    this.onClear,
    this.onSearch,
    this.onFilter,
  });

  bool get hasKeyword => keyword != null && keyword!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,

      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,

      toolbarHeight:
      AppBarDimensions.appBarHeight - AppBarDimensions.dividerHeight,

      leading: IconButton(
        icon: const Icon(AppIcons.back),
        onPressed: onBack ?? () => Navigator.of(context).maybePop(),
      ),

      titleSpacing: 0,

      title: Padding(
        padding: const EdgeInsets.only(
          right: AppSpacing.md,
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: AppBarDimensions.searchBarHeight,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.gray3),
                  borderRadius: BorderRadius.circular(AppBorderRadius.md),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        keyword ?? '검색 버튼을 눌러주세요.',
                        style: hasKeyword
                            ? AppTextStyles.cardTitle
                            : AppTextStyles.inputPlaceholder,
                      ),
                    ),

                    hasKeyword
                        ? IconButton(
                      onPressed: onClear,
                      icon: const Icon(
                        AppIcons.cancel,
                        size: AppIcons.sizeMd,
                        color: AppColors.gray4,
                      ),
                    )
                        : IconButton(
                      onPressed: onSearch,
                      icon: const Icon(
                        AppIcons.search,
                        size: AppIcons.sizeXl,
                        color: AppColors.gray2,
                      ),
                    ),

                    const VerticalDivider(width: AppSpacing.lg),

                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(dateText ?? '',
                            style: AppTextStyles.inputTextSm),
                        Text(
                          DatePeopleTextUtil.people(peopleCount),
                          style: AppTextStyles.inputTextSm,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: AppSpacing.sm),

            Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              child: InkWell(
                onTap: onFilter,
                customBorder: const CircleBorder(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.menuSelected),
                  ),
                  child: const Icon(
                    AppIcons.tune,
                    size: AppIcons.sizeLg,
                    color: AppColors.menuSelected,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(AppBarDimensions.dividerHeight),
        child: Divider(height: AppBarDimensions.dividerHeight),
      ),
    );

  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(AppBarDimensions.appBarHeight);
}
