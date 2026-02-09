class ChatConversation {
  final int chatConversationsId;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatConversation({
    required this.chatConversationsId,
    required this.userId,
    required this.createdAt,
    required this.updatedAt
  });

  factory ChatConversation.fromJson(Map<String, dynamic> json) {
    return ChatConversation(
      chatConversationsId: (json['chatConversationsId'] ?? 0) as int,
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