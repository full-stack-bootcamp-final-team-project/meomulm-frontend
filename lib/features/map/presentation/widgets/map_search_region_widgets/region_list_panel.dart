import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';

/// "상위 지역 목록"을 왼쪽 패널 형태로 보여주는 위젯
class RegionListPanel extends StatelessWidget {
  final List<String> regions;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final double width;

  const RegionListPanel({
    super.key,
    required this.regions,
    required this.selectedIndex,
    required this.onSelect,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    const double _panelMinWidth = 120;
    const double _panelMaxWidth = 260;
    const double _listItemHeight = 56;
    const double _selectedIndicatorWidth = 3;

    return Container(
      width: width,
      constraints: const BoxConstraints(
        minWidth: _panelMinWidth,
        maxWidth: _panelMaxWidth,
      ),
      color: AppColors.gray5,
      child: ListView.builder(
        itemCount: regions.length,
        itemBuilder: (context, index) {
          final isSelected = index == selectedIndex;

          return InkWell(
            onTap: () => onSelect(index),
            child: Container(
              height: _listItemHeight,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.white
                    : Colors.transparent,
                border: Border(
                  left: BorderSide(
                    color: isSelected
                        ? AppColors.black
                        : Colors.transparent,
                    width: _selectedIndicatorWidth,
                  ),
                ),
              ),
              child: Text(
                regions[index],
                style: isSelected
                    ? AppTextStyles.cardTitle
                    : AppTextStyles.bodyLg,
              ),
            ),
          );
        },
      ),
    );
  }
}
