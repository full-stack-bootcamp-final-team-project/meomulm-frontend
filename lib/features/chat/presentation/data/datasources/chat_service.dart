import 'package:dio/dio.dart';
import 'package:meomulm_frontend/features/chat/presentation/data/models/chat_message.dart';
import 'package:meomulm_frontend/features/chat/presentation/data/models/chat_request.dart';
import 'package:meomulm_frontend/features/chat/presentation/data/models/chat_response.dart';

import 'package:meomulm_frontend/core/constants/app_constants.dart';

class ChatService {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiPaths.chatUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 30),
    contentType: 'application/json',
    responseType: ResponseType.json,
  ));

  /// 백엔드 서버로 메시지를 보내고 응답을 받는 함수
  static Future<ChatResponse> sendMessage(ChatRequest request) async {
    try {
      final response = await _dio.post(
        '/message',
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return ChatResponse.fromJson(response.data);
      } else {
        throw Exception('서버 응답 오류: ${response.statusCode}');
      }
    } catch (e) {
      print("통신 에러 발생: $e");
      throw Exception('서버와 연결할 수 없습니다. 네트워크를 확인해주세요.');
    }
  }

  // 방 목록을 가져옴
  static Future<List<ChatResponse>> getUserConversations(String token) async {
    try {
      final response = await _dio.get(
        '/conversations',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final List<dynamic> data = response.data;
      return data.map((json) => ChatResponse.fromJson(json)).toList();
    } catch (e) {
      throw Exception('방 목록 로드 실패: $e');
    }
  }

  /// 메시지 내역을 가져옴
  static Future<List<ChatMessage>> getChatHistory(int conversationId, String token) async {
    try {
      final response = await _dio.get('/conversations/$conversationId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => ChatMessage.fromJson(json)).toList();
      } else {
        throw Exception('메세지 내역을 불러오지 못했습니다.');
      }
    } catch (e) {
      throw Exception('메시지 내역 로드 실패: $e');
    }
  }
}