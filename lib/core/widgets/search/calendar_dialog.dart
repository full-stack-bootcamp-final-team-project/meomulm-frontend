import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_colors.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarDialog extends StatefulWidget {
  final DateTimeRange? initialRange;

  const CalendarDialog({super.key, this.initialRange});

  @override
  State<CalendarDialog> createState() => _CalendarDialogState();
}

class _CalendarDialogState extends State<CalendarDialog> {
  late DateTime focusedDay;
  DateTime? rangeStart;
  DateTime? rangeEnd;

  @override
  void initState() {
    super.initState();
    focusedDay = widget.initialRange?.start ?? DateTime.now();
    rangeStart = widget.initialRange?.start;
    rangeEnd = widget.initialRange?.end;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxHeight = 520.0;
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
            const SizedBox(height: 16),
            const Text(
              '날짜 선택',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),

            Flexible(
              fit: FlexFit.loose,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  onPageChanged: (day) {
                    focusedDay = day;
                  },

                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

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
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('취소'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.onPressed,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
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
