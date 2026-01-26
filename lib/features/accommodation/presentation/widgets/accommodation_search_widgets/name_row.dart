import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/accommodation_search_widgets/search_row.dart';

class NameRow extends StatelessWidget {
  final TextEditingController controller;

  const NameRow({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SearchRow(
      leading: const Icon(
        Icons.location_on_outlined,
        color: Colors.grey,
        size: 24,
      ),
      child: TextField(
        controller: controller,
        decoration: const InputDecoration(
          hintText: '숙소명, 지역',
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
