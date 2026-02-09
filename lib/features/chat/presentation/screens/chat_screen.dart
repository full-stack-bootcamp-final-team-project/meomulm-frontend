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
    _initChat();

    // // 화면 시작 시 대화 이력 불러오기
    // _loadChatHistory();
  }

  /// 최초 진입 시 로그인 / 미로그인 분기
  Future<void> _initChat() async {
    final auth = context.read<AuthProvider>();
    final token = auth.token;

    if (!auth.isLoggedIn || token == null) {
      _initGuestChat();
    } else {
      await _loadChatHistory(token!);
    }
  }

  /// 미로그인 기본 상태
  void _initGuestChat() {
    setState(() {
      messages = [
        ChatMessage(
          chatMessagesId: -1,
          conversationId: -1,
          message: '안녕하세요 😊\n로그인 없이도 간단한 질문은 가능해요!',
          isUserMessage: false,
          createdAt: DateTime.now(),
        ),
      ];
    });
    _scrollToBottom();
  }

  /// 대화 이력 로드 함수
  Future<void> _loadChatHistory(String token) async {
    setState(() => loading = true);

    try {
      // 방 가져오기
      final List<ChatMessage> rooms = await ChatService.getUserConversations(
        token!,
      );

      if (rooms.isNotEmpty) {
        final int targetConversationId = rooms[0].conversationId;

        // 메세지 가져오기
        final List<ChatMessage> history = await ChatService.getChatHistory(
          targetConversationId,
          token!,
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

      if (token != null && token!.isNotEmpty) {
        // Gemini API -> 백엔드 서버로 요청
        final response = await ChatService.sendMessage(token, text.trim());

        setState(() {
          // 5. 응답 메세지
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
