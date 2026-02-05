import 'package:flutter/cupertino.dart';
import 'package:meomulm_frontend/features/chat/presentation/data/models/chat_message.dart';
import 'package:meomulm_frontend/features/chat/presentation/widgets/chat_bubble.dart';
import 'package:meomulm_frontend/features/chat/presentation/widgets/empty_message.dart';

class MessageList extends StatelessWidget {
  final List<ChatMessage> messages;
  final ScrollController scrollController;

  const MessageList({
    super.key,
    required this.messages,
    required this.scrollController
  });

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      return const EmptyMessage();
    }
    return ListView.builder(
        controller: scrollController,
        itemCount: messages.length,
        itemBuilder: (context, index) {
          return ChatBubble(message: messages[index]);
        });
  }
}