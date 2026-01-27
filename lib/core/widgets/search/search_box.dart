import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/core/widgets/search/calendar_dialog.dart';
import 'package:meomulm_frontend/core/widgets/search/date_select_row.dart';
import 'package:meomulm_frontend/core/widgets/search/guest_count_row.dart';

class SearchBox extends StatelessWidget {
  final double width;
  final Widget firstRow;
  final DateTimeRange? dateRange;
  final int guestCount;
  final ValueChanged<DateTimeRange?> onDateChanged;
  final ValueChanged<int> onGuestChanged;

  const SearchBox({
    super.key,
    required this.width,
    required this.firstRow,
    required this.dateRange,
    required this.guestCount,
    required this.onDateChanged,
    required this.onGuestChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.md,
        ),
        decoration: AppCardStyles.card,
        child: Column(
          children: [
            firstRow,
            const Divider(height: 1),
            DateSelectRow(
              dateText: _formatDateRange(dateRange),
              onTap: () => _showCalendar(context),
            ),
            const Divider(height: 1),
            GuestCountRow(
              count: guestCount,
              onPlus: () => onGuestChanged(guestCount + 1),
              onMinus: guestCount > 1
                  ? () => onGuestChanged(guestCount - 1)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateRange(DateTimeRange? range) {
    if (range == null) {
      final now = DateTime.now();
      final tomorrow = now.add(const Duration(days: 1));
      return '${_formatDate(now)} - ${_formatDate(tomorrow)}';
    }
    return '${_formatDate(range.start)} - ${_formatDate(range.end)}';
  }

  String _formatDate(DateTime date) {
    return '${date.year}년 ${date.month}월 ${date.day}일';
  }

  Future<void> _showCalendar(BuildContext context) async {
    final result = await showDialog<DateTimeRange>(
      context: context,
      builder: (_) => CalendarDialog(initialRange: dateRange),
    );
    if (result != null) onDateChanged(result);
  }
}
