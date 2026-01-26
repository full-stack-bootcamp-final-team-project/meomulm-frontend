import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/accommodation_search_widgets/search_row.dart';

class GuestRow extends StatelessWidget {
  final int guestCount;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const GuestRow({
    super.key,
    required this.guestCount,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return SearchRow(
      leading: const Icon(
        Icons.person_outline,
        color: Colors.grey,
      ),
      child: Row(
        children: [
          const Text(
            '인원',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          _iconButton(Icons.remove, onRemove),
          Text(
            '$guestCount',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          _iconButton(Icons.add, onAdd),
        ],
      ),
    );
  }

  Widget _iconButton(IconData icon, VoidCallback onPressed) {
    return SizedBox(
      width: 36,
      height: 36,
      child: IconButton(
        padding: EdgeInsets.zero,
        iconSize: 20,
        icon: Icon(icon),
        onPressed: onPressed,
      ),
    );
  }
}
