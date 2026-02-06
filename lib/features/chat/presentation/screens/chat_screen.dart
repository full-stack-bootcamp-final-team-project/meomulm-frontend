import 'dart:ffi';

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

  // 스크롤 컨트롤러
  final ScrollController _scrollController = ScrollController();

  // 대화 리스트
  List<ChatMessage> messages = [];

  bool loading = false;

  @override
  void initState() {
    super.initState();
    // 화면 시작 시 대화 이력 불러오기
    _loadChatHistory();
  }

  /// 대화 이력 로드 함수
  Future<void> _loadChatHistory() async {
    if (!mounted) return;

    final auth = context.read<AuthProvider>();

    if (!auth.isLoggedIn || auth.token == null) {
      print("로그인 상태가 아니어서 이력을 불러오지 않습니다.");
      return;
    }

    setState(() => loading = true);

    try {
      // 방 가져오기
      final List<ChatMessage> rooms = await ChatService.getUserConversations(
        auth.token!,
      );

      if (rooms.isNotEmpty) {
        final Long targetConversationId = rooms[0].conversationId;

        // 메세지 가져오기
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

  // 메시지 추가 후 자동 스크롤
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

  // 메세지 보내기
  void sendMessage() async {
    String text = inputController.text;
    if (text.isEmpty) return;

    setState(() {
      loading = true;
    });
    _scrollToBottom();

    inputController.clear(); // 메세지 보낸 후 input 창 비우기

    try {
      // 로그인 안 할 때
      final token = context.read<AuthProvider>().token;

      if (token != null || token!.isNotEmpty) {
        // Gemini API -> 백엔드 서버로 요청
        final response = await ChatService.sendMessage(token, text.trim());

        setState(() {
          // 5. 응답 메세지
          messages.add(
            ChatMessage(
              chatMessageId: response.chatMessageId,
              conversationId: response.conversationId,
              message: response.message,
              isUserMessage: response.isUserMessage,
              createdAt: response.createdAt,
            ),
          );
          loading = false;
        });
        _scrollToBottom();
      } else {
        loading = false;
        _scrollToBottom();
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('오류 : $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(title: TitleLabels.chat),
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
        ],
      ),
      // TODO 입력창
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
