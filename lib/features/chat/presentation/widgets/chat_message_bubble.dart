import 'package:flutter/cupertino.dart';

import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/features/chat/presentation/data/models/chat_message.dart';

// 메세지 말풍선
class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isUser;

  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.65,
        ),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: isUser ? AppColors.main : AppColors.gray5,
            borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          ),
          child: Text(
            message.message,
            style: TextStyle(
              color: isUser ? AppColors.white : AppColors.black,
            ),
          ),
        ),
      ),
    );
  }
}
