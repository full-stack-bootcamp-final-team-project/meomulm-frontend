import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotificationToast extends StatelessWidget {
  final Map<String, dynamic> notification;
  final VoidCallback onDismiss;
  final Function(int) onRead;

  const NotificationToast({
    super.key,
    required this.notification,
    required this.onDismiss,
    required this.onRead,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: InkWell(
            onTap: () {
              // 1. 읽음 처리 (DB 업데이트 등)
              onRead(notification['notificationId'] ?? 0);
              // 2. 링크 이동
              final String? linkUrl = notification['notificationLinkUrl'];
              // null 체크와 빈 문자열 체크를 동시에 (AND 연산자 사용)
              if (linkUrl != null && linkUrl.isNotEmpty) {
                context.push(linkUrl);
              }
              // 3. 토스트 닫기
              onDismiss();
            },
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFF007AFF),
                  radius: 18,
                  child: Icon(Icons.notifications_active, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "새로운 알림",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      Text(
                        notification['notificationContent'] ?? "알림 내용이 없습니다.",
                        style: const TextStyle(fontSize: 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: onDismiss,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}