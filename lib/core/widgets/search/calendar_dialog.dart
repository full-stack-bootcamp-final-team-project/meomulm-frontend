import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarDialog extends StatefulWidget {
  final DateTimeRange? initialRange;

  const CalendarDialog({super.key, this.initialRange});

  @override
  State<CalendarDialog> createState() => _CalendarDialogState();
}

class _CalendarDialogState extends State<CalendarDialog> {
  late DateTime focusedDay;
  late DateTime? rangeStart;
  late DateTime? rangeEnd;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final tomorrow = now.add(const Duration(days: 1));

    // 기본값: 오늘 ~ 내일
    focusedDay = widget.initialRange?.start ?? now;
    rangeStart = widget.initialRange?.start ?? now;
    rangeEnd = widget.initialRange?.end ?? tomorrow;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxHeight = 620;
    final maxPadding = (MediaQuery.of(context).size.height - maxHeight) / 2;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: maxPadding,
      ),
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppSpacing.lg),
            const Text(
              '날짜 선택',
              style: AppTextStyles.cardTitle,
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),

            Flexible(
              fit: FlexFit.loose,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: TableCalendar(
                  firstDay: DateTime.now(),
                  lastDay: DateTime.now().add(const Duration(days: 730)),
                  focusedDay: focusedDay,
                  rangeStartDay: rangeStart,
                  rangeEndDay: rangeEnd,
                  rangeSelectionMode: RangeSelectionMode.enforced,

                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: AppColors.onPressed.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    rangeStartDecoration: const BoxDecoration(
                      color: AppColors.onPressed,
                      shape: BoxShape.circle,
                    ),
                    rangeEndDecoration: const BoxDecoration(
                      color: AppColors.onPressed,
                      shape: BoxShape.circle,
                    ),
                    rangeHighlightColor: AppColors.onPressed.withOpacity(0.2),
                    selectedDecoration: const BoxDecoration(
                      color: AppColors.onPressed,
                      shape: BoxShape.circle,
                    ),
                    tableBorder: const TableBorder(
                      horizontalInside: BorderSide.none,
                      verticalInside: BorderSide.none,
                      top: BorderSide.none,
                      bottom: BorderSide.none,
                      left: BorderSide.none,
                      right: BorderSide.none,
                    ),
                  ),

                  onRangeSelected: (start, end, _) {
                    setState(() {
                      rangeStart = start;
                      rangeEnd = end;
                      if (start != null) focusedDay = start;
                    });
                  },
                  onPageChanged: (day) => setState(() => focusedDay = day),

                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.gray2,
                        side: BorderSide(color: AppColors.gray5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('취소'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.onPressed,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                        ),
                      ),
                      onPressed: rangeStart != null && rangeEnd != null
                          ? () {
                        Navigator.pop(
                          context,
                          DateTimeRange(
                            start: rangeStart!,
                            end: rangeEnd!,
                          ),
                        );
                      }
                          : null,
                      child: const Text('확인'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}