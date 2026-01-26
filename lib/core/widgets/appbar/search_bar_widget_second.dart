import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/core/utils/date_people_utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/providers/accommodation_provider.dart';

class SearchBarAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onBack;
  final VoidCallback? onClear;
  final VoidCallback? onFilter;

  const SearchBarAppBar({
    super.key,
    this.onBack,
    this.onClear,
    this.onFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AccommodationProvider>(
      builder: (context, provider, _) {
        final keyword = provider.locationName ?? provider.accommodationName ?? '';
        final hasKeyword = keyword.isNotEmpty;

        final dateText =
            '${provider.checkIn.year}.${provider.checkIn.month}.${provider.checkIn.day} - ${provider.checkOut.year}.${provider.checkOut.month}.${provider.checkOut.day}';
        final peopleCount = provider.guestCount;

        return AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          toolbarHeight: AppBarDimensions.appBarHeight - AppBarDimensions.dividerHeight,
          leading: IconButton(
            icon: const Icon(AppIcons.back),
            onPressed: onBack ?? () => Navigator.of(context).maybePop(),
          ),
          titleSpacing: 0,
          title: Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: AppBarDimensions.searchBarHeight,
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.gray3),
                      borderRadius: BorderRadius.circular(AppBorderRadius.md),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            hasKeyword ? keyword : '검색 버튼을 눌러주세요.',
                            style: hasKeyword
                                ? AppTextStyles.cardTitle
                                : AppTextStyles.inputPlaceholder,
                          ),
                        ),

                        // 키워드 존재 시 클리어, 없으면 검색 버튼
                        hasKeyword
                            ? IconButton(
                          onPressed: () => provider.clearSearchData(),
                          icon: const Icon(
                            AppIcons.cancel,
                            size: AppIcons.sizeMd,
                            color: AppColors.gray4,
                          ),
                        )
                            : IconButton(
                          onPressed: () {
                            // 필요 시 검색 화면 열기
                          },
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
                            Text(dateText, style: AppTextStyles.inputTextSm),
                            Text(
                              '$peopleCount명', // 혹은 DatePeopleTextUtil.people(peopleCount)
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
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(AppBarDimensions.appBarHeight);
}
