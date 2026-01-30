import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meomulm_frontend/core/widgets/dialogs/snack_messenger.dart';

class TitleSection extends StatelessWidget {
  final String name;

  const TitleSection({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. 롱프레스를 감지하기 위해 GestureDetector로 감쌉니다.
          GestureDetector(
            onLongPressStart: (details) => _showCopyMenu(context, details.globalPosition),
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 18),
        ],
      ),
    );
  }

  // 2. 복사하기 말풍선 메뉴를 띄우는 메서드
  void _showCopyMenu(BuildContext context, Offset offset) async {
    final result = await showMenu<String>(
      context: context,
      // 터치한 좌표(offset)에 메뉴를 띄웁니다.
      position: RelativeRect.fromLTRB(offset.dx, offset.dy, offset.dx, offset.dy),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      items: [
        const PopupMenuItem(
          value: 'copy',
          child: Row(
            children: [
              Icon(Icons.copy, size: 18),
              SizedBox(width: 8),
              Text('숙소명 복사'),
            ],
          ),
        ),
      ],
    );

    // 3. 'copy'를 선택했을 때 클립보드에 저장
    if (result == 'copy') {
      await Clipboard.setData(ClipboardData(text: name));

      if (context.mounted) {
        SnackMessenger.showMessage(
            context,
            "숙소명이 복사되었습니다.",
            bottomPadding: 85,
            type: ToastType.success
        );
      }
    }
  }
}