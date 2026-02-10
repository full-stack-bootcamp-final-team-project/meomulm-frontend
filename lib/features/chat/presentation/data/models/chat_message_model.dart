class ChatMessage {
  final int chatMessageId;
  final int conversationId;
  // 메세지
  final String message;
  // 유저/봇 여부 확인
  final bool isUserMessage;
  // 메세지를 전달 시간
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
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    );
  }
}