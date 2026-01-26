import 'package:flutter/material.dart';
import 'row_container.dart';

class DateSelectRow extends StatelessWidget {
  final String dateText;
  final VoidCallback onTap;

  const DateSelectRow({
    super.key,
    required this.dateText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: RowContainer(
        child: Row(
          children: [
            const Icon(Icons.calendar_month_outlined, color: Colors.grey),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                dateText,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
