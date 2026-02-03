import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/providers/notification_toast.dart';
import 'package:meomulm_frontend/features/accommodation/data/datasources/notification_service.dart';
import 'package:meomulm_frontend/core/router/app_router.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class NotificationProvider extends ChangeNotifier {
  StompClient? stompClient;
  List<Map<String, dynamic>> _notifications = [];

  List<Map<String, dynamic>> get notifications => _notifications;

  void connect(String token) {
    // 1. HTTP 서비스 인터셉터에 토큰 설정
    NotificationService.setupInterceptors(token);

    if (stompClient != null && stompClient!.isActive) return;

    stompClient = StompClient(
      config: StompConfig(
        url: 'ws://10.0.2.2:9000/ws/websocket',   // iOS 시뮬레이터 -> localhost
        onConnect: (frame) => _onConnect(frame, token),
        stompConnectHeaders: {'Authorization': 'Bearer $token'},
        onWebSocketError: (error) => print("웹소켓 에러: $error"),
      ),
    );
    stompClient?.activate();
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

      // 알림 식별값 생성
      final String uniqueId = DateTime.now().millisecondsSinceEpoch.toString();
      final notificationData = {...data, 'id': uniqueId};

      _notifications.add(notificationData);
      notifyListeners();

      // 전역 Context를 사용해서 어떤 화면에서든 팝업 표시
      final context = AppRouter.navigatorKey.currentContext;
      if (context != null) {
        showOverlayNotification(context, notificationData);
      }
    }
  }

  void showOverlayNotification(BuildContext context, Map<String, dynamic> data) {
    OverlayState? overlayState = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10, // 노치 아래 여유 공간
        left: 0,
        right: 0,
        child: NotificationToast(
          notification: data,
          onDismiss: () {
            if (overlayEntry.mounted) overlayEntry.remove();
          },
          onRead: (id) async {
            try {
              await NotificationService.updateNotificationStatus(notificationId: id);
              print("ID: $id 알림 읽음 처리 완료");
            } catch (e) {
              print("읽음 처리 실패: $e");
            }
          },
        ),
      ),
    );

    overlayState.insert(overlayEntry);

    // 4초 후 자동 삭제
    Future.delayed(const Duration(milliseconds: 4000), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
        // 팝업이 사라지면 메모리 알림 리스트에서도 제거 (선택 사항)
        _notifications.removeWhere((n) => n['id'] == data['id']);
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    stompClient?.deactivate();
    super.dispose();
  }
}