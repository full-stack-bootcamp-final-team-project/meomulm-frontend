import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/widgets/appbar/app_bar_widget.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:meomulm_frontend/features/chat/presentation/data/datasources/chat_service.dart';
import 'package:meomulm_frontend/features/chat/presentation/data/models/chat_message_model.dart';
import 'package:meomulm_frontend/features/chat/presentation/widgets/loading_indicator.dart';
import 'package:meomulm_frontend/features/chat/presentation/widgets/message_input.dart';
import 'package:meomulm_frontend/features/chat/presentation/widgets/message_list.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<ChatMessage> messages = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _loadChatHistory();
  }

  Future<void> _loadChatHistory() async {
    if (!mounted) return;

    final auth = context.read<AuthProvider>();

    if (!auth.isLoggedIn || auth.token == null) {
      print("비로그인 상태 -  새로운 대화 시작");
      return;
    }

    setState(() => loading = true);

    try {
      final List<ChatMessage> rooms = await ChatService.getUserConversations(
        auth.token!,
      );

      if (rooms.isNotEmpty) {
        final int targetConversationId = rooms[0].conversationId;
        final List<ChatMessage> history = await ChatService.getChatHistory(
          targetConversationId,
          auth.token!,
        );

        setState(() {
          messages = history;
        });

        print("대화 내역 로드 완료: ${messages.length}개의 메시지");
        _scrollToBottom();
      } else {
        print("참여 중인 대화방이 없습니다.");
      }
    } catch (e) {
      print("이력 로드 중 상세 오류: $e");
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: AppDurations.medium,
        curve: Curves.easeOut,
      );
    });
  }

  void sendMessage() async {
    String text = inputController.text.trim();
    if (text.isEmpty) return;

    final auth = context.read<AuthProvider>();
    final token = auth.isLoggedIn ? auth.token : null;
    final isLoggedIn = token != null && token.isNotEmpty;

    print(isLoggedIn
        ? "로그인 사용자 메시지 전송"
        : "비로그인 사용자 메시지 전송 (DB 저장 안됨)");

    // 1. 사용자 메시지를 먼저 화면에 추가
    final userMessage = ChatMessage(
      chatMessagesId: 0,
      conversationId: messages.isNotEmpty ? messages[0].conversationId : 0,
      message: text,
      isUserMessage: true,
      createdAt: DateTime.now(),
    );

    setState(() {
      messages.add(userMessage);
      loading = true;
    });

    inputController.clear();
    _scrollToBottom();

    try {
      print('메시지 전송: $text');
      final response = await ChatService.sendMessage(token, text);
      print('응답 받음: ${response.message}');

      setState(() {
        messages.add(
          ChatMessage(
            chatMessagesId: response.chatMessagesId,
            conversationId: response.conversationId,
            message: response.message,
            isUserMessage: response.isUserMessage,
            createdAt: response.createdAt,
          ),
        );
        loading = false;
      });
      _scrollToBottom();
    } catch (e) {
      print('메시지 전송 실패: $e');

      // 비로그인 사용자를 위한 임시 폴백 응답
      if (!isLoggedIn) {
        setState(() {
          messages.add(
            ChatMessage(
              chatMessagesId: 0,
              conversationId: 0,
              message: '안녕하세요! 머묾 챗봇입니다.\n\n'
                  '현재 게스트 모드에서는 일부 기능이 제한됩니다.\n'
                  '완전한 기능을 이용하시려면 로그인해주세요.\n\n'
                  '숙소 예약이나 문의사항이 있으시면 언제든 말씀해주세요.',
              isUserMessage: false,
              createdAt: DateTime.now(),
            ),
          );
          loading = false;
        });
        _scrollToBottom();

        // 에러 메시지는 표시하지 않음 (사용자 경험 개선)
        return;
      }

      // 로그인 사용자의 경우 에러 처리
      setState(() {
        loading = false;
        messages.removeLast(); // 사용자 메시지 제거
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('메시지 전송 실패: 서버 연결을 확인해주세요'),
            backgroundColor: Colors.red.shade400,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isLoggedIn = auth.isLoggedIn;

    return Scaffold(
      appBar: const AppBarWidget(title: TitleLabels.chat),
      body: Column(
        children: [
          // 비로그인 사용자 안내 메시지
          if (!isLoggedIn)
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.amber.shade50,
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: Colors.amber.shade800),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '게스트 모드입니다. 로그인하시면 대화 내역이 저장됩니다.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.amber.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // 메시지 리스트
          Expanded(
            child: MessageList(
              messages: messages,
              scrollController: _scrollController,
            ),
          ),

          // 로딩 표시
          if (loading) const LoadingIndicator(),
        ],
      ),
      // 입력창
      bottomNavigationBar: SafeArea(
        child: MessageInput(
          controller: inputController,
          onSend: sendMessage,
          isLoading: loading,
        ),
      ),
    );
  }
}