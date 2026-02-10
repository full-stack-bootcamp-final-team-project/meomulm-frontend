import 'package:flutter/cupertino.dart';
import 'package:meomulm_frontend/core/theme/app_colors.dart';
import 'package:meomulm_frontend/core/theme/app_dimensions.dart';
import 'package:meomulm_frontend/core/theme/app_icons.dart';
import 'package:meomulm_frontend/core/theme/app_text_styles.dart';

/// ===============================
/// 별점 Row
/// - 터치 위치에 따라 0.5 단위로 변경
/// ===============================
class RatingRow extends StatelessWidget {
  final double rating;
  final ValueChanged<double> onChanged;
  final double Function(double dx, double width) ratingFromDx;

  const RatingRow({
    required this.rating,
    required this.onChanged,
    required this.ratingFromDx,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _HalfStarBar(
          rating: rating,
          onChanged: onChanged,
          ratingFromDx: ratingFromDx,
        ),
        const SizedBox(width: AppSpacing.md),
        Text(
          '${rating.toStringAsFixed(1)} / 5.0',
          style: AppTextStyles.bodyLg,
        ),
      ],
    );
  }
}

/// ===============================
/// 별 5개를 0.5 단위로 조절 가능한 바
/// ===============================
class _HalfStarBar extends StatelessWidget {
  final double rating;
  final ValueChanged<double> onChanged;
  final double Function(double dx, double width) ratingFromDx;

  const _HalfStarBar({
    required this.rating,
    required this.onChanged,
    required this.ratingFromDx,
  });

  @override
  Widget build(BuildContext context) {
    const starSize = AppIcons.sizeLg;
    const starColor = AppColors.ratingColor;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = (starSize * 5) + AppSpacing.xl;

        return SizedBox(
          width: width,
          height: starSize,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (d) => onChanged(ratingFromDx(d.localPosition.dx, width)),
            onHorizontalDragUpdate: (d) =>
                onChanged(ratingFromDx(d.localPosition.dx, width)),
            child: Row(
              children: List.generate(5, (i) {
                final starIndex = i + 1.0;

                IconData icon;
                if (rating >= starIndex) {
                  icon = AppIcons.starRounded;
                } else if (rating >= starIndex - 0.5) {
                  icon = AppIcons.starHalfRounded;
                } else {
                  icon = AppIcons.starBorderRounded;
                }

                return Padding(
                  padding: EdgeInsets.only(right: i == 4 ? 0 : AppSpacing.xs),
                  child: Icon(
                      icon,
                      size: starSize,
                      color: (icon == AppIcons.starRounded ||
                          icon == AppIcons.starHalfRounded)
                          ? AppColors.ratingColor
                          : AppColors.gray4
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}