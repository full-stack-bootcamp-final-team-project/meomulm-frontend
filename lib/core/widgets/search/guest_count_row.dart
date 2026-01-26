import 'package:flutter/material.dart';
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
          const Icon(Icons.person_outline, color: Colors.grey),
          const SizedBox(width: 12),
          const Text(
            '인원',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          _IconBtn(icon: Icons.remove, onTap: onMinus),
          Text(
            '$count',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          _IconBtn(icon: Icons.add, onTap: onPlus),
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
      child: IconButton(
        padding: EdgeInsets.zero,
        iconSize: 20,
        icon: Icon(icon),
        onPressed: onTap,
      ),
    );
  }
}
