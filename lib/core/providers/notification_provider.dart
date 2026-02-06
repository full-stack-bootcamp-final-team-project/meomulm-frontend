import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/providers/notification_toast.dart';
import 'package:meomulm_frontend/features/accommodation/data/datasources/notification_api_service.dart';
import 'package:meomulm_frontend/core/router/app_router.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class NotificationProvider extends ChangeNotifier {
  StompClient? stompClient;
  List<Map<String, dynamic>> _notifications = [];

  List<Map<String, dynamic>> get notifications => _notifications;

  void connect(String token) {
    NotificationApiService.setupInterceptors(token);

    // 이미 연결된 상태라면 재연결 방지한다.
    if (stompClient != null && stompClient!.isActive) return;

    stompClient = StompClient(
      config: StompConfig(
        url: 'ws://localhost:8080/ws/websocket',   // iOS 시뮬레이터 -> localhost
        onConnect: (frame) => _onConnect(frame, token),
        reconnectDelay: const Duration(seconds: 3),
        stompConnectHeaders: {'Authorization': 'Bearer $token'},
        onWebSocketError: (error) => print("웹소켓 에러: $error"),
        onDebugMessage: (msg) => print("STOMP 디버그: $msg"), // 상세 로그 확인용
      ),
    );
    stompClient?.activate();
  }

  void disconnect() {
    if (stompClient != null && stompClient!.isActive) {
      stompClient?.deactivate();
      stompClient = null;
      debugPrint("실시간 알림 연결 해제됨");
    }
  }

  void _onConnect(StompFrame frame, String token) {
    print('실시간 알림 연결 성공');
    stompClient?.subscribe(
      destination: '/topic/notifications',
      callback: (frame) => _handleIncomingMessage(frame),
    );
    stompClient?.subscribe(
      destination: '/user/queue/notifications',
      callback: (frame) => _handleIncomingMessage(frame),
    );
  }

  void _handleIncomingMessage(StompFrame frame) {
    if (frame.body != null) {
      final Map<String, dynamic> data = json.decode(frame.body!);
      print("📩 수신된 알림 데이터: $data");

      // 백엔드 Map 구조를 프론트 모델 키값에 맞게 매핑
      final notificationData = {
        'notificationId': data['id'] ?? 0,
        'notificationContent': data['notificationContent'] ?? '알림 내용이 없습니다.',
        'notificationLinkUrl': data['notificationLinkUrl'] ?? '',
        'userId': data['userId'],
        'isRead': false,
        'createdAt': DateTime.now().toIso8601String(),
      };

      _notifications.add(notificationData);
      notifyListeners();

      showOverlayNotification(notificationData);
    }
  }

  void showOverlayNotification(Map<String, dynamic> data) {
    final OverlayState? overlayState = AppRouter.navigatorKey.currentState?.overlay;

    if (overlayState == null) {
      print("⚠️ 오버레이를 찾을 수 없습니다.");
      return;
    }

    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        // 상태바(노치) 아래에 위치하도록 패딩 추가
        top: MediaQuery.of(context).padding.top + 4,
        left: 0,
        right: 0,
        child: NotificationToast(
          notification: data,
          onDismiss: () {
            if (overlayEntry.mounted) overlayEntry.remove();
          },
          onRead: (id) async {
            try {
              if (id != 0) {
                await NotificationApiService.updateNotificationStatus(notificationId: id);
                print("🆗 ID: $id 알림 읽음 처리 완료");
              }
            } catch (e) {
              print("❌ 읽음 처리 실패: $e");
            }
          },
        ),
      ),
    );

    overlayState.insert(overlayEntry);

    // 4초 후 자동 소멸
    Future.delayed(const Duration(seconds: 4), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }

  @override
  void dispose() {
    stompClient?.deactivate();
    super.dispose();
  }
}