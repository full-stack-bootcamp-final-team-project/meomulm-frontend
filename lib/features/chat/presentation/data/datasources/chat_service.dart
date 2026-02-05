import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:meomulm_frontend/features/chat/presentation/data/models/chat_request.dart';
import 'package:meomulm_frontend/features/chat/presentation/data/models/chat_response.dart';

class ChatService {
  // 본인 컴퓨터에서 실행 중일 때: Android 에뮬레이터는 10.0.2.2, iOS는 localhost
  static const String baseUrl = "http://localhost:8080/api/chat";

  /// 백엔드 서버로 메시지를 보내고 응답을 받는 함수
  static Future<ChatResponse> sendMessage(ChatRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/message'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        // 한글 깨짐 방지를 위해 utf8.decode 처리
        final decodedBody = utf8.decode(response.bodyBytes);
        return ChatResponse.fromJson(jsonDecode(decodedBody));
      } else {
        throw Exception('서버 응답 오류: ${response.statusCode}');
      }
    } catch (e) {
      print("통신 에러 발생: $e");
      throw Exception('서버와 연결할 수 없습니다. 네트워크를 확인해주세요.');
    }
  }

  /// 특정 대화방의 이전 기록을 가져오고 싶을 때 사용
  static Future<List<dynamic>> getHistory(int conversationId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/conversations/$conversationId'),
        headers: {
          'Accept': 'application/json', // JSON으로 결과를 보내달라고 요청
        },
      );

      if (response.statusCode == 200) {
        // 리스트 형태로 온 메세지 UTF-8 변환 반환
        final String decodedBody = utf8.decode(response.bodyBytes);
        return jsonDecode(decodedBody);
      } else {
        throw Exception('이력 로드 에러! 코드: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('이력을 가져오지 못했습니다: $e');
    }
  }
}