import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/widgets/appbar/app_bar_widget.dart';
import 'package:meomulm_frontend/features/chat/presentation/data/datasources/chat_service.dart';
import 'package:meomulm_frontend/features/chat/presentation/data/models/chat_message.dart';
import 'package:meomulm_frontend/features/chat/presentation/widgets/loading_indicator.dart';
import 'package:meomulm_frontend/features/chat/presentation/widgets/message_input.dart';
import 'package:meomulm_frontend/features/chat/presentation/widgets/message_list.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController controller = TextEditingController();

  // 스크롤 컨트롤러
  final ScrollController _scrollController = ScrollController();

  // 대화 리스트
  List<ChatMessage> messages = [];

  bool loading = false;

  // 백엔드 대화 히스토리
  List<Map<String, String>> conversationHistory = [];

  // 메시지 추가 후 자동 스크롤
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  // 메세지 보내기
  void sendMessage() async {
    String text = controller.text;
    if (text.isEmpty) return;

    setState(() {
      messages.add(ChatMessage(text, true, DateTime.now())); // 대화 리스트에 저장
      loading = true;
    });
    _scrollToBottom();

    controller.clear(); // 메세지 보낸 후 input 창 비우기

    try {
      // Gemini API 호출
      final response =
      await ChatService.AIsendMessage(text, conversationHistory); // api 를 이용해서 메세지 전송

      // 유저/봇 확인해서 추가
      conversationHistory.add({'message': text, 'isUser': 'true'});
      conversationHistory.add({'message': response, 'isUser': 'false'});

      setState(() {
        // 보낸 내용, 응답 결과 기록
        messages.add(ChatMessage(response, false, DateTime.now()));
        loading = false;
      });
      _scrollToBottom();
    } catch (e) {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('오류 : $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const AppBarWidget(title: '머묾 채팅'),
        body: Column(
          children: [
            // 메세지 리스트
            Expanded(
              // 메세지 기록들을 전달
              child: MessageList(
                messages: messages,
                scrollController: _scrollController,
              ),
            ),

            // 로딩 표시
            if (loading) const LoadingIndicator(),

            // 입력창
            MessageInput(
              controller: controller,
              onSend: sendMessage,
              isLoading: loading
            )
          ],
        ));
  }
}