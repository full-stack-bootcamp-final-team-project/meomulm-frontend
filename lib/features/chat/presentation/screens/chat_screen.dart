import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/widgets/appbar/app_bar_widget.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:meomulm_frontend/features/chat/presentation/data/datasources/chat_service.dart';
import 'package:meomulm_frontend/features/chat/presentation/data/models/chat_message.dart';
import 'package:meomulm_frontend/features/chat/presentation/data/models/chat_request.dart';
import 'package:meomulm_frontend/features/chat/presentation/data/models/chat_response.dart';
import 'package:meomulm_frontend/features/chat/presentation/widgets/loading_indicator.dart';
import 'package:meomulm_frontend/features/chat/presentation/widgets/message_input.dart';
import 'package:meomulm_frontend/features/chat/presentation/widgets/message_list.dart';
import 'package:meomulm_frontend/features/my_page/presentation/providers/user_profile_provider.dart';
import 'package:provider/provider.dart';


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
  int? conversationId;

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
      final List<ChatResponse> rooms = await ChatService.getUserConversations(auth.token!);

      if (rooms.isNotEmpty) {
        final int targetConversationId = rooms[0].conversationId;
        conversationId = targetConversationId;

        // 메세지 가져오기
        final List<ChatMessage> history = await ChatService.getChatHistory(targetConversationId, auth.token!);

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
    String text = controller.text;
    if (text.isEmpty) return;

    setState(() {
      messages.add(ChatMessage(message: text, isUser: true, time: DateTime.now())); // 대화 리스트에 저장
      loading = true;
    });
    _scrollToBottom();

    controller.clear(); // 메세지 보낸 후 input 창 비우기

    try {
      final user = context.read<UserProfileProvider>().user;
      final effectiveUserId = user?.userId ?? 0;

      // 2. 백엔드용 요청 객체
      final request = ChatRequest(effectiveUserId, text, conversationId);

      // Gemini API -> 백엔드 서버로 요청
      final response = await ChatService.sendMessage(request);

      setState(() {
        // 4. 대화방 ID 저장
        conversationId = response.conversationId;

        // 5. 응답 메세지
        messages.add(ChatMessage(
          message: response.message,
          isUser: response.isUserMessage,
          time: response.timestamp,
        ));
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
      // 입력창
      bottomNavigationBar: SafeArea(
        child: MessageInput(
          controller: controller,
          onSend: sendMessage,
          isLoading: loading,
        ),
      ),
    );
  }
}