class ChatConversation {
  final int id;
  final String userId;
  final DateTime updatedAt;

  ChatConversation({required this.id, required this.userId, required this.updatedAt});

  factory ChatConversation.fromJson(Map<String, dynamic> json) {
    return ChatConversation(
      id: json['id'] as int,
      userId: json['userId'].toString(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }
}