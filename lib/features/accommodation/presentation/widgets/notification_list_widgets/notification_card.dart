import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/features/accommodation/data/models/notification_response_model.dart';
import 'package:meomulm_frontend/features/accommodation/data/datasources/notification_service.dart';
import 'package:meomulm_frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class NotificationCard extends StatelessWidget {
  final NotificationResponseModel notification;
  final VoidCallback? onTap; // 클릭 후 상태 갱신을 위한 콜백

  const NotificationCard({
    super.key,
    required this.notification,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isRead = notification.is_read;
    final Color unreadColor = const Color(0xFF007AFF);

    return GestureDetector(
      onTap: () async {
        // 1. 읽지 않은 알림이라면 읽음 처리 API 호출
        if (!isRead) {
          final auth = context.read<AuthProvider>();
          try {
            // 별도의 updateRead API가 있다면 호출 (없다면 delete 방식처럼 구성)
            // 여기서는 탭 시 콜백을 실행하여 리스트를 새로고침하거나 상태를 변경하도록 유도
            if (onTap != null) onTap!();
          } catch (e) {
            debugPrint('읽음 처리 실패: $e');
          }
        }

        // 2. 링크가 있다면 이동
        if (notification.notificationLinkUrl.isNotEmpty) {
          context.push(notification.notificationLinkUrl);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12), // Dismissible과 결합을 위해 Padding 대신 Margin 사용
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상태 아이콘 (Blue Dot)
            Container(
              margin: const EdgeInsets.only(top: 6, right: 12),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isRead ? Colors.transparent : unreadColor,
              ),
            ),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.notificationContent,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: isRead ? FontWeight.w400 : FontWeight.w600,
                      color: isRead ? const Color(0xFF8E8E93) : const Color(0xFF1C1C1E),
                      height: 1.4,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatDate(notification.createdAt),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFFC7C7CC),
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ),

            if (notification.notificationLinkUrl.isNotEmpty)
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: Color(0xFFD1D1D6),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final DateTime dt = DateTime.parse(dateStr);
      final now = DateTime.now();
      final difference = now.difference(dt);

      if (difference.inMinutes < 60) return '${difference.inMinutes}분 전';
      if (difference.inHours < 24) return '${difference.inHours}시간 전';
      return '${dt.month}월 ${dt.day}일';
    } catch (e) {
      return dateStr;
    }
  }
}