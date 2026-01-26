import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/accommodation_result_widgets/result_summaryBar.dart';

class ResultTopBar extends StatelessWidget
    implements PreferredSizeWidget {

  const ResultTopBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, size: 28),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: ResultSummaryBar(
              width: width * 0.8, // ← 여기서 계산
            ),
          ),
        ],
      ),
    );
  }
}
