import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meomulm_frontend/core/theme/app_colors.dart';
import 'package:meomulm_frontend/core/providers/filter_provider.dart';
import 'package:meomulm_frontend/core/theme/app_dimensions.dart';
import 'package:meomulm_frontend/core/theme/app_text_styles.dart';
import 'package:provider/provider.dart';


class AccommodationFilterPrice extends StatefulWidget {
  const AccommodationFilterPrice({super.key});

  @override
  State<AccommodationFilterPrice> createState() => _AccommodationFilterPriceState();
}

class _AccommodationFilterPriceState extends State<AccommodationFilterPrice> {
  late TextEditingController _minController;
  late TextEditingController _maxController;

  @override
  void initState() {
    super.initState();
    // AccommodationProvider → FilterProvider로 변경
    final provider = context.read<FilterProvider>();
    _minController = TextEditingController(text: provider.priceRange.start.toInt().toString());
    _maxController = TextEditingController(text: provider.priceRange.end.toInt().toString());
  }

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  void _onTextChange() {
    final min = double.tryParse(_minController.text) ?? 0;
    final max = double.tryParse(_maxController.text) ?? 200;

    if (min <= max && max <= 200) {
      context.read<FilterProvider>().setPriceRange(RangeValues(min, max));
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FilterProvider>();

    final currentMin = provider.priceRange.start.toInt().toString();
    final currentMax = provider.priceRange.end.toInt().toString();
    if (_minController.text != currentMin) _minController.text = currentMin;
    if (_maxController.text != currentMax) _maxController.text = currentMax;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('가격 범위', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        const SizedBox(height: 20),

        Row(
          children: [
            _buildPriceField(_minController, '0', _onTextChange),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Text('~', style: TextStyle(color: AppColors.gray3, fontSize: 18)),
            ),
            _buildPriceField(_maxController, '200', _onTextChange),
          ],
        ),

        const SizedBox(height: 10),

        SliderTheme(
          data: SliderThemeData(
            trackHeight: 5,
            activeTrackColor: AppColors.onPressed,
            inactiveTrackColor: AppColors.gray6,
            activeTickMarkColor: AppColors.onPressed,
            inactiveTickMarkColor: AppColors.gray6,
            tickMarkShape: SliderTickMarkShape.noTickMark,
            thumbColor: Colors.white,
            overlayColor: Colors.black.withOpacity(0.1),
            rangeThumbShape: const RoundRangeSliderThumbShape(
              enabledThumbRadius: 10,
              elevation: 3,
              pressedElevation: 4,
            ),
            rangeTrackShape: const RoundedRectRangeSliderTrackShape(),
          ),
          child: RangeSlider(
            min: 0,
            max: 200,
            divisions: 20,
            values: provider.priceRange,
            onChanged: (values) {
              provider.setPriceRange(values);
              _minController.text = values.start.toInt().toString();
              _maxController.text = values.end.toInt().toString();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPriceField(TextEditingController controller, String hint, VoidCallback onChanged) {
    return Expanded(
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          border: Border.all(color: AppColors.gray5, width: 1.5),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                textAlign: TextAlign.end,
                style: AppTextStyles.bodyLg,
                decoration: InputDecoration(
                  hintText: hint,
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: (_) => onChanged(),
              ),
            ),
            const SizedBox(width: 4),
            const Text('만원', style: AppTextStyles.bodyMd),
          ],
        ),
      ),
    );
  }
}