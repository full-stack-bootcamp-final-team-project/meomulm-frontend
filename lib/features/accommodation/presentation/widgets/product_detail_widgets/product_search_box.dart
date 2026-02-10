import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/constants/ui/labels_constants.dart';
import 'package:meomulm_frontend/core/theme/app_colors.dart';
import 'package:meomulm_frontend/core/theme/app_decorations.dart';
import 'package:meomulm_frontend/core/theme/app_dimensions.dart';
import 'package:meomulm_frontend/core/theme/app_text_styles.dart';
import 'package:meomulm_frontend/core/widgets/search/calendar_dialog.dart';
import 'package:meomulm_frontend/core/widgets/search/date_select_row.dart';
import 'package:meomulm_frontend/core/widgets/search/guest_count_row.dart';

class ProductSearchBox extends StatefulWidget {
  final double width;
  final DateTimeRange? dateRange;
  final int guestCount;
  final ValueChanged<DateTimeRange?> onDateChanged;
  final ValueChanged<int> onGuestChanged;
  final VoidCallback? onApply;

  const ProductSearchBox({
    super.key,
    required this.width,
    required this.dateRange,
    required this.guestCount,
    required this.onDateChanged,
    required this.onGuestChanged,
    this.onApply,
  });

  @override
  State<ProductSearchBox> createState() => _ProductSearchBoxState();
}

class _ProductSearchBoxState extends State<ProductSearchBox> {
  late DateTimeRange? _dateRange;
  late int _guestCount;

  @override
  void initState() {
    super.initState();
    _dateRange = widget.dateRange;
    _guestCount = widget.guestCount;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: widget.width,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.md,
        ),
        decoration: AppCardStyles.card,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 날짜 선택
            DateSelectRow(
              dateText: _formatDateRange(_dateRange),
              onTap: () async {
                final result = await showDialog<DateTimeRange>(
                  context: context,
                  builder: (_) => CalendarDialog(initialRange: _dateRange),
                );
                if (result != null) {
                  setState(() => _dateRange = result);
                  // ✅ 여기서는 로컬 상태만 변경, Provider는 아직 변경하지 않음
                }
              },
            ),
            const Divider(height: 1),

            // 인원 선택
            GuestCountRow(
              count: _guestCount,
              onPlus: () => setState(() => _guestCount++),
              onMinus: _guestCount > 1 ? () => setState(() => _guestCount--) : null,
            ),
            const SizedBox(height: AppSpacing.md),

            // 적용 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // ✅ Apply 버튼 누를 때만 Provider에 적용
                  widget.onDateChanged(_dateRange);
                  widget.onGuestChanged(_guestCount);

                  if (widget.onApply != null) {
                    widget.onApply!(); // 모달 닫기 & rooms reload
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.onPressed,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                  ),
                ),
                child: const Text(
                  ButtonLabels.apply,
                  style: AppTextStyles.buttonLg,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateRange(DateTimeRange? range) {
    if (range == null) return '';
    return '${range.start.month}.${range.start.day} ~ ${range.end.month}.${range.end.day}';
  }
}
