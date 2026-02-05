class ChatMessage {
  // 메세지
  final String message;
  // 유저/봇 여부 확인
  final bool isUser;
  // 메세지를 전달 시간
  final DateTime time;

  ChatMessage(this.message, this.isUser, this.time);
}