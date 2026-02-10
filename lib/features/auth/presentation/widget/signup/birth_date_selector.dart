import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_colors.dart';
import 'package:meomulm_frontend/core/widgets/input/form_label.dart';


class BirthDateSelector extends StatefulWidget {
  final TextEditingController birthController;

  const BirthDateSelector({
    super.key,
    required this.birthController,
  });

  @override
  State<BirthDateSelector> createState() => _BirthDateSelectorState();
}

class _BirthDateSelectorState extends State<BirthDateSelector> {
  Timer? _debounceTimer;

  // 날짜 범위 지정
  final List<String> _year = List.generate(
    2020 - 1950 + 1,
        (i) => (1950 + i).toString(),
  );
  final List<String> _month = List.generate(12, (i) => (i + 1).toString());
  final List<String> _day = List.generate(31, (i) => (i + 1).toString());

  // 날짜 초기값
  String _selectYear = '';
  String _selectMonth = '';
  String _selectDay = '';

  // 날짜 합차기 (2000-01-01)
  void _updateBirthController() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 100), () {
      if (_selectYear.isNotEmpty &&
          _selectMonth.isNotEmpty &&
          _selectDay.isNotEmpty) {
        setState(() {
          widget.birthController.text =
          '$_selectYear-${_selectMonth.padLeft(2, '0')}-${_selectDay.padLeft(2, '0')}';
        });
      }
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormLabel(label: "생년월일", isRequired: true),
        Row(
          children: [
            Expanded(
              child: _dropdownField(
                hint: 'YYYY',
                items: _year,
                value: _selectYear.isEmpty ? null : _selectYear,
                onChanged: (y) {
                  setState(() {
                    _selectYear = y!;
                  });
                  _updateBirthController();
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _dropdownField(
                hint: 'MM',
                items: _month,
                value: _selectMonth.isEmpty ? null : _selectMonth,
                onChanged: (m) {
                  setState(() {
                    _selectMonth = m!;
                  });
                  _updateBirthController();
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _dropdownField(
                hint: 'DD',
                items: _day,
                value: _selectDay.isEmpty ? null : _selectDay,
                onChanged: (d) {
                  setState(() {
                    _selectDay = d!;
                  });
                  _updateBirthController();
                },
              ),
            ),
          ],
        ),
        // 선택된 생년월일 표시
        if (widget.birthController.text.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              '선택된 생년월일: ${widget.birthController.text}',
              style: TextStyle(
                color: AppColors.main,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  // dropdown 버튼
  Widget _dropdownField({
    required String hint,
    required List<String> items,
    required String? value,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: value != null ? AppColors.main : const Color(0xFFCACACA),
          width: value != null ? 2 : 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(
            hint,
            style: TextStyle(color: AppColors.gray2),
          ),
          value: value,
          style: TextStyle(
            color: AppColors.black,
            fontSize: 16,
          ),
          items: items
              .map((e) => DropdownMenuItem<String>(
            value: e,
            child: Text(e),
          ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}