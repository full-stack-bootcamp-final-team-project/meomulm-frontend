import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import 'package:meomulm_frontend/core/theme/app_styles.dart';

// 메세지 시간
class ChatMessageTime extends StatelessWidget {
  final DateTime time;

  const ChatMessageTime({super.key, required this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xxs),
      child: Text(
        DateFormat('HH:mm').format(time),
        style: const TextStyle(
          fontSize: 10,
          color: AppColors.gray2,
        ),
      ),
    );
  }
}
