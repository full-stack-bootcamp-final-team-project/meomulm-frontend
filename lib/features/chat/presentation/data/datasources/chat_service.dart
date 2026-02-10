import 'package:dio/dio.dart';
import 'package:meomulm_frontend/features/chat/presentation/data/models/chat_conversation_model.dart';
import 'package:meomulm_frontend/features/chat/presentation/data/models/chat_message_model.dart';

import 'package:meomulm_frontend/core/constants/app_constants.dart';

class ChatService {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiPaths.chatUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 30),
    contentType: 'application/json',
    responseType: ResponseType.json,
  ));

  /// 백엔드 서버로 메시지를 보내고 응답을 받는 함수  (로그인/비로그인 모두 지원)
  /// [token] 로그인 시 토큰 (선택적)
  /// [message] 전송할 메시지
  static Future<ChatMessage> sendMessage(String? token, String message) async {
    try {
      // 요청 헤더 설정 (토큰이 있을 경우에만 Authorization 추가)
      Map<String, dynamic> headers = {};
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      print('요청 정보: ${token != null ? "로그인" : "비로그인"} / 메시지: $message');

      final response = await _dio.post(
        '',  // 빈 경로 (baseUrl 사용)
        options: Options(
          headers: headers,
          validateStatus: (status) => status! < 600,  // 모든 응답을 받아서 처리
        ),
        data: {'message': message},  // JSON body로 메시지 전송
      );

      print('응답 코드: ${response.statusCode}');
      print('응답 데이터: ${response.data}');

      if (response.statusCode == 200) {
        return ChatMessage.fromJson(response.data);
      } else if (response.statusCode == 500) {
        // 서버 에러 상세 정보 출력
        final errorMessage = response.data is Map
            ? response.data['message'] ?? response.data.toString()
            : response.data.toString();
        print('서버 에러 (500): $errorMessage');
        throw Exception('서버 처리 중 오류: $errorMessage');
      } else {
        throw Exception('서버 응답 오류: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print("DioException 발생: ${e.type}");
      print("에러 메시지: ${e.message}");
      print("응답 코드: ${e.response?.statusCode}");
      print("응답 데이터: ${e.response?.data}");

      if (e.response?.statusCode == 500) {
        final errorData = e.response?.data;
        final errorMessage = errorData is Map
            ? errorData['message'] ?? '서버 내부 오류'
            : '서버 내부 오류';
        throw Exception('서버 오류: $errorMessage');
      }

      throw Exception('서버와 연결할 수 없습니다. 네트워크를 확인해주세요.');
    } catch (e) {
      print("통신 에러 발생: $e");
      rethrow;
    }
  }

  /// 방 목록을 가져옴 (로그인 필수)
  static Future<List<ChatConversation>> getUserConversations(String token) async {
    try {
      final response = await _dio.get(
        '/conversations',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final List<dynamic> data = response.data;
      print('data: $data');
      return data.map((json) => ChatConversation.fromJson(json)).toList();
    } catch (e) {
      throw Exception('방 목록 로드 실패: $e');
    }
  }

  /// 메시지 내역을 가져옴 (로그인 필수)
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