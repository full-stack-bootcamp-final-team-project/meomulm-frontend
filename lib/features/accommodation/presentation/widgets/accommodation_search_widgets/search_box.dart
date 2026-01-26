import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/widgets/search/calendar_dialog.dart';
import 'package:meomulm_frontend/core/widgets/search/date_select_row.dart';
import 'package:meomulm_frontend/core/widgets/search/guest_count_row.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/accommodation_search_widgets/location_input_row.dart';

class SearchBox extends StatefulWidget {
  final double width;
  final String location;
  final DateTimeRange? dateRange;
  final int guestCount;
  final ValueChanged<String> onLocationChanged;
  final ValueChanged<DateTimeRange?> onDateChanged;
  final ValueChanged<int> onGuestChanged;

  const SearchBox({
    super.key,
    required this.width,
    required this.location,
    required this.dateRange,
    required this.guestCount,
    required this.onLocationChanged,
    required this.onDateChanged,
    required this.onGuestChanged,
  });

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  late TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    _locationController = TextEditingController(text: widget.location);
    _locationController.addListener(_onLocationTextChanged);
  }

  @override
  void didUpdateWidget(SearchBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.location != oldWidget.location &&
        widget.location != _locationController.text) {
      _locationController.text = widget.location;
    }
  }

  void _onLocationTextChanged() {
    widget.onLocationChanged(_locationController.text);
  }

  String _formatDate() {
    if (widget.dateRange == null) return '날짜 선택';
    final s = widget.dateRange!.start;
    final e = widget.dateRange!.end;
    return '${s.year}.${s.month}.${s.day} - ${e.year}.${e.month}.${e.day}';
  }

  Future<void> _openCalendar() async {
    final result = await showDialog<DateTimeRange>(
      context: context,
      builder: (_) => CalendarDialog(initialRange: widget.dateRange),
    );

    if (result != null) {
      widget.onDateChanged(result);
    }
  }

  void _onGuestPlus() {
    widget.onGuestChanged(widget.guestCount + 1);
  }

  void _onGuestMinus() {
    if (widget.guestCount > 1) {
      widget.onGuestChanged(widget.guestCount - 1);
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
            LocationInputRow(controller: _locationController),
            const Divider(height: 1),

            DateSelectRow(
              dateText: _formatDate(),
              onTap: _openCalendar,
            ),
            const Divider(height: 1),

            GuestCountRow(
              count: widget.guestCount,
              onPlus: _onGuestPlus,
              onMinus: widget.guestCount <= 1 ? null : _onGuestMinus,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _locationController.removeListener(_onLocationTextChanged);
    _locationController.dispose();
    super.dispose();
  }
}