import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_colors.dart';
import 'package:meomulm_frontend/core/theme/app_text_styles.dart';
import 'package:meomulm_frontend/core/widgets/search/row_container.dart';

class GuestCountRow extends StatelessWidget {
  final int count;
  final VoidCallback onPlus;
  final VoidCallback? onMinus;

  const GuestCountRow({
    super.key,
    required this.count,
    required this.onPlus,
    this.onMinus,
  });

  @override
  Widget build(BuildContext context) {
    return RowContainer(
      child: Row(
        children: [
          const Icon(
              Icons.person_outline,
              color: AppColors.gray2
          ),
          const SizedBox(width: 12),
          const Text(
            '인원',
            style: AppTextStyles.inputTextLg,
          ),
          const Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _IconBtn(icon: Icons.remove, onTap: onMinus),
              SizedBox(
                width: 32,
                child: Text(
                  '$count',
                  style: AppTextStyles.cardTitle,
                  textAlign: TextAlign.center,
                ),
              ),
              _IconBtn(icon: Icons.add, onTap: onPlus),
            ],
          ),
        ],
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _IconBtn({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 36,
      child: Transform.translate(
        offset: const Offset(0, 2),
        child: IconButton(
          padding: EdgeInsets.zero,
          iconSize: 20,
          icon: Icon(icon),
          onPressed: onTap,
        ),
      ),
    );
  }
}