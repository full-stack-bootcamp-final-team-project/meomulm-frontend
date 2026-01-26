import 'package:flutter/material.dart';

class DateRangeModal extends StatefulWidget {
  final DateTimeRange? initialRange;

  const DateRangeModal({super.key, this.initialRange});

  @override
  State<DateRangeModal> createState() => _DateRangeModalState();
}

class _DateRangeModalState extends State<DateRangeModal> {
  DateTime? _start;
  DateTime? _end;

  @override
  void initState() {
    super.initState();
    _start = widget.initialRange?.start;
    _end = widget.initialRange?.end;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                '날짜 선택',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(height: 1),

            /// 🔥 핵심: 캘린더는 Flexible
            Flexible(
              child: CalendarDatePicker(
                initialDate: _start ?? DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                onDateChanged: (date) {
                  setState(() {
                    if (_start == null || _end != null) {
                      _start = date;
                      _end = null;
                    } else {
                      _end = date.isAfter(_start!) ? date : _start;
                    }
                  });
                },
              ),
            ),

            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _start != null && _end != null
                      ? () {
                    Navigator.pop(
                      context,
                      DateTimeRange(start: _start!, end: _end!),
                    );
                  }
                      : null,
                  child: const Text('확인'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
