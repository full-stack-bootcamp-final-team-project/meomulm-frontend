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

  // 대화 리스트
  List<ChatMessage> messages = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    // 화면 시작 시 대화 이력 불러오기
    _loadChatHistory();
  }

  /// 대화 이력 로드 함수 (수정됨)
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
      final rooms = await ChatService.getUserConversations(auth.token!);

      if (rooms.isNotEmpty) {
        final int targetConversationId = rooms[0].chatConversationId;

        // 메시지 가져오기
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

  // 메세지 보내기 (수정됨)
  void sendMessage() async {
    String text = inputController.text.trim();
    if (text.isEmpty) return;

    final token = context.read<AuthProvider>().token;

    // ✅ null 체크 수정 (OR → AND)
    if (token == null || token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('로그인이 필요합니다'))
      );
      return;
    }

    // ✅ 사용자 메시지를 먼저 UI에 추가
    final tempUserMessage = ChatMessage(
      chatMessageId: 0,  // 임시 ID
      conversationId: messages.isNotEmpty ? messages[0].conversationId : 0,
      message: text,
      isUserMessage: true,
      createdAt: DateTime.now(),
    );

    setState(() {
      messages.add(tempUserMessage);
      loading = true;
    });

    inputController.clear();
    _scrollToBottom();

    try {
      // Gemini API -> 백엔드 서버로 요청
      final response = await ChatService.sendMessage(token, text);

      setState(() {
        // ✅ 임시 메시지 제거 후 실제 응답 추가
        messages.removeLast();

        // 서버로부터 받은 사용자 메시지와 봇 응답 추가
        // (백엔드가 봇 응답만 반환하므로 이것만 추가)
        messages.add(response);
        loading = false;
      });
      _scrollToBottom();

    } catch (e) {
      setState(() {
        // 에러 발생 시 임시 메시지 제거
        messages.removeLast();
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('오류 : $e'))
      );
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
            child: MessageList(
              messages: messages,
              scrollController: _scrollController,
            ),
          ),

          // 로딩 표시
          if (loading) const LoadingIndicator(),
        ],
      ),
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