class ChatMessage {
  // 메세지
  final String message;
  // 유저/봇 여부 확인
  final bool isUser;
  // 메세지를 전달 시간
  final DateTime time;

  ChatMessage({
    required this.message,
    required this.isUser,
    required this.time
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      message: json['message'] ?? '',
      isUser: json['isUserMessage'] ?? false,
      time: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    );
  }
}