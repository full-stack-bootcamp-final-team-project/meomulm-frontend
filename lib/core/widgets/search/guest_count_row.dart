import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';

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
    return SizedBox(
      height: 52,
      child: Row(
        children: [
          const Icon(AppIcons.person),
          const SizedBox(width: AppSpacing.md),
          const Text('인원', style: AppTextStyles.bodyLg),
          const Spacer(),
          _CountButton(icon: AppIcons.remove, onTap: onMinus),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Text('$count', style: AppTextStyles.bodyLg),
          ),
          _CountButton(icon: AppIcons.add, onTap: onPlus),
        ],
      ),
    );
  }
}

class _CountButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _CountButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
      iconSize: AppIcons.sizeMd,
      icon: Icon(icon),
      onPressed: onTap,
    );
  }
}
