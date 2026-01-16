import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';

// 달력
class DateRangeField extends StatelessWidget {
  final DateTimeRange? selectedRange;
  final VoidCallback onTap;

  const DateRangeField({
    super.key,
    required this.selectedRange,
    required this.onTap,
  });

  String _formatDateRange() {
    if (selectedRange == null) return '날짜 선택';
    final s = selectedRange!.start;
    final e = selectedRange!.end;
    const days = ['월', '화', '수', '목', '금', '토', '일'];
    return '${s.year}년 ${s.month}월 ${s.day}일 (${days[s.weekday - 1]}) - '
        '${e.year}년 ${e.month}월 ${e.day}일 (${days[e.weekday - 1]})';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            AppIcons.calendarMonth,
            size: AppIcons.sizeLg,
            color: AppColors.gray2,
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Text(
              _formatDateRange(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: selectedRange == null
                  ? AppTextStyles.bodyLg.copyWith(color: AppColors.gray2)
                  : AppTextStyles.bodyLg,
            ),
          ),
          const Icon(
            AppIcons.arrowDown,
            size: AppIcons.sizeMd,
            color: AppColors.gray2,
          ),
        ],
      ),
    );
  }
}
