import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/features/accommodation/data/models/search_accommodation_response_model.dart';
import 'package:meomulm_frontend/features/home/presentation/widgets/home_arrow_button_widget.dart';
import 'package:meomulm_frontend/features/home/presentation/widgets/home_item_card.dart';

import 'package:meomulm_frontend/core/constants/app_constants.dart';

/// 이 외 세션 영역(숙소 리스트)
class HomeSectionWidget extends StatelessWidget {
  final double width, height;
  final String title;
  final bool isHot;
  final List<SearchAccommodationResponseModel> items;
  final ScrollController controller;
  final void Function(ScrollController, double, double, bool) scrollByItem;

  const HomeSectionWidget({
    super.key,
    required this.width,
    required this.height,
    required this.title,
    required this.isHot,
    required this.items,
    required this.controller,
    required this.scrollByItem,
  });

  @override
  Widget build(BuildContext context) {
    const horizontalPadding = AppSpacing.lg;
    const itemSpacing = AppSpacing.lg;
    final itemWidth = (width - horizontalPadding * 2 - itemSpacing * 3) / 4;

    final hasItems = items.isNotEmpty;
    final message = title == '최근 본 숙소'
        ? EmptyMessages.recentAccommodationsEmpty
        : EmptyMessages.accommodations;
    return SizedBox(
      height: height + AppSpacing.xxxl,
      child: Stack(
        children: [
          // 세션 타이틀 영역
          Positioned(
            left: horizontalPadding,
            top: 0,
            child: Row(
              children: [
                Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.black)),
                if (isHot)
                  Container(
                    margin: const EdgeInsets.only(left: AppSpacing.xs),
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: AppSpacing.xxs),
                    color: AppColors.black,
                    child: Text('HOT', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.white)),
                  ),
              ],
            ),
          ),

          // 세션 내용 영역
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child:  hasItems
                ? SingleChildScrollView(
              controller: controller,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  items.length,
                      (i) => HomeItemCard(
                      item: items[i],
                      width: itemWidth,
                      isLast: i == items.length - 1
                  ),
                ),
              ),
            )
                : SizedBox(
              height: height * 0.7,
              child: Center(
                child: Text(
                  message,
                  style: AppTextStyles.bodyMd.copyWith(
                    color: AppColors.gray2,
                  ),
                ),
              ),
            ),
          ),
          // 세션 화살표
          if (hasItems) ...[
            ArrowButtonWidget(left: AppSpacing.md, top: height * 0.4, isLeft: true, onTap: () => scrollByItem(controller, itemWidth, itemSpacing, true)),
            ArrowButtonWidget(left: width - AppSpacing.md - AppSpacing.lg, top: height * 0.4, isLeft: false, onTap: () => scrollByItem(controller, itemWidth, itemSpacing, false)),
          ],
        ],
      ),
    );
  }
}