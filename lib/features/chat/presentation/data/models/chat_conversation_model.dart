class ChatConversation {
  final int chatConversationId;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatConversation({
    required this.chatConversationId,
    required this.userId,
    required this.createdAt,
    required this.updatedAt
  });

  factory ChatConversation.fromJson(Map<String, dynamic> json) {
    return ChatConversation(
      chatConversationId: (json['chatConversationId'] ?? 0) as int,
      userId: json['userId'] as int,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }
}