import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class SearchBox extends StatefulWidget {
  final double width;

  const SearchBox({super.key, required this.width});

  @override
  SearchBoxState createState() => SearchBoxState();
}

class SearchBoxState extends State<SearchBox> {
  static const double _rowHeight = 52;

  final TextEditingController _locationController = TextEditingController();

  DateTimeRange? selectedRange;
  int guestCount = 2;

  /// 외부 접근용
  String get locationText => _locationController.text;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    selectedRange = DateTimeRange(
      start: DateTime(now.year, now.month, now.day),
      end: DateTime(now.year, now.month, now.day + 1),
    );
  }

  String _formatDate() {
    if (selectedRange == null) return '날짜 선택';

    final s = selectedRange!.start;
    final e = selectedRange!.end;
    final days = ['월', '화', '수', '목', '금', '토', '일'];

    return '${s.year}.${s.month}.${s.day} (${days[s.weekday - 1]}) - '
        '${e.year}.${e.month}.${e.day} (${days[e.weekday - 1]})';
  }

  Future<void> _openCalendarDialog() async {
    DateTime focusedDay = selectedRange?.start ?? DateTime.now();
    DateTime? rangeStart = selectedRange?.start;
    DateTime? rangeEnd = selectedRange?.end;

    final result = await showDialog<DateTimeRange>(
      context: context,
      builder: (_) {
        final maxHeight = MediaQuery.of(context).size.height * 0.7;

        return Dialog(
          insetPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: StatefulBuilder(
                builder: (context, setDialogState) {
                  return Column(
                    children: [
                      const Text(
                        '날짜 선택',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Divider(height: 1),
                      const SizedBox(height: 8),

                      Expanded(
                        child: TableCalendar(
                          firstDay: DateTime.now(),
                          lastDay:
                          DateTime.now().add(const Duration(days: 730)),
                          focusedDay: focusedDay,
                          rangeStartDay: rangeStart,
                          rangeEndDay: rangeEnd,
                          rangeSelectionMode:
                          RangeSelectionMode.enforced,
                          onRangeSelected: (start, end, _) {
                            setDialogState(() {
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
                          calendarStyle: CalendarStyle(
                            rangeStartDecoration: const BoxDecoration(
                              color: Color(0xFF6F63C0),
                              shape: BoxShape.circle,
                            ),
                            rangeEndDecoration: const BoxDecoration(
                              color: Color(0xFF6F63C0),
                              shape: BoxShape.circle,
                            ),
                            rangeHighlightColor:
                            const Color(0xFF6F63C0).withOpacity(0.12),
                            todayDecoration: BoxDecoration(
                              color: const Color(0xFF1E88E5)
                                  .withOpacity(0.4),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () =>
                                  Navigator.pop(context),
                              child: const Text('취소'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              onPressed:
                              rangeStart != null && rangeEnd != null
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
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                const Color(0xFF6F63C0),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                '확인',
                                style:
                                TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );

    if (result != null) {
      setState(() => selectedRange = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: widget.width,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFC1C1C1)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            /// 숙소명
            _RowContainer(
              child: Row(
                children: [
                  const Icon(Icons.location_on_outlined,
                      color: Colors.grey),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _locationController,
                      decoration: const InputDecoration(
                        hintText: '숙소명, 지역',
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            /// 날짜
            GestureDetector(
              onTap: _openCalendarDialog,
              child: _RowContainer(
                child: Row(
                  children: [
                    const Icon(Icons.calendar_month_outlined,
                        color: Colors.grey),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _formatDate(),
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Divider(height: 1),

            /// 인원
            _RowContainer(
              child: Row(
                children: [
                  const Icon(Icons.person_outline,
                      color: Colors.grey),
                  const SizedBox(width: 12),
                  const Text(
                    '인원',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  _IconBtn(
                    icon: Icons.remove,
                    onTap: guestCount <= 1
                        ? null
                        : () => setState(() => guestCount--),
                  ),
                  Text(
                    '$guestCount',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  _IconBtn(
                    icon: Icons.add,
                    onTap: () =>
                        setState(() => guestCount++),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }
}

/// --------------------
/// 공통 Row 컨테이너
class _RowContainer extends StatelessWidget {
  final Widget child;

  const _RowContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: child,
    );
  }
}

/// 인원 버튼
class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _IconBtn({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 36,
      child: IconButton(
        padding: EdgeInsets.zero,
        iconSize: 20,
        icon: Icon(icon),
        onPressed: onTap,
      ),
    );
  }
}
