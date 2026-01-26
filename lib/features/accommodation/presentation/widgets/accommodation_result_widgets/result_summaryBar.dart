import 'package:flutter/cupertino.dart';

class ResultSummaryBar extends StatelessWidget {
  final double width;

  const ResultSummaryBar({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: width,
        height: 45,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF8B8B8B)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const Text(
              '서울',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            Container(
              width: 1,
              height: 24,
              color: const Color(0xFFC1C1C1),
            ),
            const SizedBox(width: 10),
            const Text(
              '12.22 - 12.23\n인원 2',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
