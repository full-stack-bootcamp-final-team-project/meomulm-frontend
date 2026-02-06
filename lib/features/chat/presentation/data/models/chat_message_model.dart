// chat_message_model.dart
class ChatMessage {
  final int chatMessageId;
  final int conversationId;
  final String message;
  final bool isUserMessage;
  final DateTime createdAt;

  ChatMessage({
    required this.chatMessageId,
    required this.conversationId,
    required this.message,
    required this.isUserMessage,
    required this.createdAt
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      chatMessageId: json['chatMessageId'] as int,
      conversationId: json['conversationId'] as int,
      message: json['message'] ?? '',
      isUserMessage: json['isUserMessage'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }
}