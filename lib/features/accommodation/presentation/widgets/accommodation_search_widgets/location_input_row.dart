import 'package:flutter/material.dart';

class LocationInputRow extends StatelessWidget {
  final TextEditingController controller;

  const LocationInputRow({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: Row(
        children: [
          const Icon(Icons.search),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: '숙소명, 지역',
                border: InputBorder.none,
                isDense: true,
              ),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
