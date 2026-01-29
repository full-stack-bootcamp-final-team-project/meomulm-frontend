import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/features/home/presentation/widgets/home_arrow_button_widget.dart';

/// 광고 영역(팀원 정보)
class AdSectionWidget extends StatelessWidget {
  final double height, width;
  final List<Map<String, String>> items;
  final ScrollController controller;
  final void Function(String url) onItemTap;
  final void Function(ScrollController, double, double, bool) scrollByItem;

  const AdSectionWidget({
    super.key,
    required this.height,
    required this.width,
    required this.items,
    required this.controller,
    required this.onItemTap,
    required this.scrollByItem,
  });

  @override
  Widget build(BuildContext context) {
    const horizontalPadding = AppSpacing.lg;
    const itemSpacing = AppSpacing.lg;
    final itemWidth = (width - horizontalPadding * 2 - itemSpacing) / 2;

    return SizedBox(
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SingleChildScrollView(
            controller: controller,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: horizontalPadding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                items.length,
                    (i) {
                  final item = items[i];
                  return GestureDetector(
                    onTap: () => onItemTap(item["url"]!),
                    child: Container(
                      width: itemWidth,
                      height: itemWidth * 0.43,
                      margin: EdgeInsets.only(right: itemSpacing),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppBorderRadius.xs),
                        image: DecorationImage(
                          image: AssetImage(item["imageUrl"]!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          ArrowButtonWidget(left: AppSpacing.md, isLeft: true, onTap: () => scrollByItem(controller, itemWidth, itemSpacing, true)),
          ArrowButtonWidget(left: width - AppSpacing.md - AppSpacing.lg, isLeft: false, onTap: () => scrollByItem(controller, itemWidth, itemSpacing, false)),
        ],
      ),
    );
  }
}