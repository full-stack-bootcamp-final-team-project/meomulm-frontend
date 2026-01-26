import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_colors.dart';
import 'package:meomulm_frontend/core/widgets/search/calendar_dialog.dart';
import 'package:meomulm_frontend/core/widgets/search/date_select_row.dart';
import 'package:meomulm_frontend/core/widgets/search/guest_count_row.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/accommodation_search_widgets/location_input_row.dart';

class SearchBox extends StatefulWidget {
  final String location;
  final DateTimeRange? dateRange;
  final int guestCount;
  final ValueChanged<String> onChangedLocation;
  final ValueChanged<DateTimeRange?> onChangedDateRange;
  final ValueChanged<int> onChangedGuestCount;

  const SearchBox({
    super.key,
    required this.location,
    required this.dateRange,
    required this.guestCount,
    required this.onChangedLocation,
    required this.onChangedDateRange,
    required this.onChangedGuestCount,
  });

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  late TextEditingController _locationController;
  late DateTimeRange? _localDateRange;
  late int _localGuestCount;

  @override
  void initState() {
    super.initState();
    // null 처리 - 초기값 없으면 오늘부터 다음날까지 기본값 할당
    _localDateRange = widget.dateRange ?? DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now().add(const Duration(days: 1)),
    );
    _localGuestCount = widget.guestCount;

    _locationController = TextEditingController(text: widget.location);
    _locationController.addListener(() {
      // 사용자가 입력값 변경 시, 부모에 콜백 호출
      widget.onChangedLocation(_locationController.text);
    });
  }

  @override
  void didUpdateWidget(covariant SearchBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 부모 위젯에서 props가 변경되면 로컬 상태를 동기화
    if (widget.location != oldWidget.location && widget.location != _locationController.text) {
      _locationController.text = widget.location;
    }

    if (widget.dateRange != oldWidget.dateRange) {
      setState(() {
        _localDateRange = widget.dateRange ?? DateTimeRange(
          start: DateTime.now(),
          end: DateTime.now().add(const Duration(days: 1)),
        );
      });
    }

    if (widget.guestCount != oldWidget.guestCount) {
      setState(() {
        _localGuestCount = widget.guestCount;
      });
    }
  }

  Future<void> _openCalendar() async {
    final result = await showDialog<DateTimeRange>(
      context: context,
      builder: (_) => CalendarDialog(initialRange: _localDateRange),
    );
    if (result != null) {
      setState(() {
        _localDateRange = result;
      });
      widget.onChangedDateRange(result);
    }
  }

  void _incrementGuest() {
    setState(() {
      _localGuestCount++;
    });
    widget.onChangedGuestCount(_localGuestCount);
  }

  void _decrementGuest() {
    if (_localGuestCount > 1) {
      setState(() {
        _localGuestCount--;
      });
      widget.onChangedGuestCount(_localGuestCount);
    }
  }

  String _formatDate() {
    if (_localDateRange == null) return '날짜 선택';
    final s = _localDateRange!.start;
    final e = _localDateRange!.end;
    return '${s.year}.${s.month}.${s.day} - ${e.year}.${e.month}.${e.day}';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.gray3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            LocationInputRow(controller: _locationController),
            const Divider(height: 1),
            DateSelectRow(dateText: _formatDate(), onTap: _openCalendar),
            const Divider(height: 1),
            GuestCountRow(
              count: _localGuestCount,
              onPlus: _incrementGuest,
              onMinus: _localGuestCount <= 1 ? null : _decrementGuest,
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
