import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/features/chat/presentation/data/models/chat_message.dart';
import 'package:meomulm_frontend/features/chat/presentation/widgets/chat_message_bubble.dart';
import 'package:meomulm_frontend/features/chat/presentation/widgets/chat_message_time.dart';


class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Row(
        // 본인/봇 메세지 구분
        mainAxisAlignment:
        isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        // 메세지 주체에 따라 위젯 순서 분기
        children: isUser
            ? [ // 본인 메세지용
                ChatMessageTime(time: message.time),
                const SizedBox(width: AppSpacing.xs),
                ChatMessageBubble(message: message, isUser: true),
              ]
            : [ // 봇 메세지용
                ChatMessageBubble(message: message, isUser: false),
                const SizedBox(width: AppSpacing.xs),
                ChatMessageTime(time: message.time),
              ],
      )
    );
  }
}