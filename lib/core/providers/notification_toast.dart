import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/router/app_router.dart';

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
              final int id = notification['notificationId'] ?? 0;
              onRead(id);

              final String? linkUrl = notification['notificationLinkUrl'];
              if (linkUrl != null && linkUrl.isNotEmpty) {
                try {
                  context.push(linkUrl);
                } catch (e) {
                  debugPrint("linkUrl 에러: $e");
                }
              }
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