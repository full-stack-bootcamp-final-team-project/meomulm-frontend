class ChatResponse {
  final int conversationId;
  final String message;
  final bool isUserMessage;
  final DateTime timestamp;


  ChatResponse({
    required this.conversationId,
    required this.message,
    required this.isUserMessage,
    required this.timestamp
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      conversationId: (json['conversationId'] ?? json['id'] ?? 0) as int,
      message: json['message'] as String? ?? '',
      isUserMessage: json['isUserMessage'] == true ||
          json['isUserMessage'].toString().toLowerCase() == 'true' ||
          json['isUserMessage'] == 1,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
    );
  }
}