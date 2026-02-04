import 'package:flutter/cupertino.dart';
import 'package:meomulm_frontend/core/theme/app_colors.dart';
import 'package:meomulm_frontend/core/theme/app_dimensions.dart';
import 'package:meomulm_frontend/core/theme/app_text_styles.dart';

/// ===============================
/// 예약 카드 리스트 래퍼
/// ===============================
class ReservationList extends StatelessWidget {
  final List<Widget> children;
  final String emptyText;

  const ReservationList({
    super.key,
    required this.children,
    required this.emptyText,
  });

  @override
  Widget build(BuildContext context) {
    // 예약내역이 없는 경우
    if (children.isEmpty) {
      return ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          const SizedBox(height: AppSpacing.xl),
          Text(
            emptyText,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMd.copyWith(color: AppColors.gray2),
          ),
        ],
      );
    }

    return ListView.separated(
      physics: AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: children.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.lg),
      itemBuilder: (context, index) => children[index],
    );
  }
}