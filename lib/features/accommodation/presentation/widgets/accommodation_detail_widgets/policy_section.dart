import 'package:flutter/material.dart';
import 'icon_text_row.dart';

class PolicySection extends StatelessWidget {
  const PolicySection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('숙소 규정', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          IconTextRow(value: '미성년자는 예약 및 숙박 불가합니다.'),
          IconTextRow(value: '체크인 기준 3일 전까지 예약 취소 가능합니다.'),
        ],
      ),
    );
  }
}