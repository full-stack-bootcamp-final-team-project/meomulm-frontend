import 'package:flutter/material.dart';
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
    final maxHeight = MediaQuery.of(context).size.height * 0.7;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                '날짜 선택',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 8),

              Expanded(
                child: TableCalendar(
                  firstDay: DateTime.now(),
                  lastDay: DateTime.now().add(const Duration(days: 730)),
                  focusedDay: focusedDay,
                  rangeStartDay: rangeStart,
                  rangeEndDay: rangeEnd,
                  rangeSelectionMode: RangeSelectionMode.enforced,
                  onRangeSelected: (start, end, _) {
                    setState(() {
                      rangeStart = start;
                      rangeEnd = end;
                      if (start != null) focusedDay = start;
                    });
                  },
                  onPageChanged: (day) => focusedDay = day,
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('취소'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
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
            ],
          ),
        ),
      ),
    );
  }
}
