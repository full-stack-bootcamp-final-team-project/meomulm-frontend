import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/theme/app_colors.dart';
import 'package:meomulm_frontend/features/accommodation/data/models/notification_response_model.dart';
import 'package:meomulm_frontend/features/accommodation/data/datasources/notification_api_service.dart';
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
    debugPrint("${notification.notificationId} : ${notification.isRead}");
    final bool isRead = notification.isRead;
    final unreadColor = const Color(0xFF007AFF);
    final backgroundColor = isRead ? AppColors.gray5 : Colors.white;

    return GestureDetector(
      onTap: () async {
        if (!notification.isRead) {
          try {
            await NotificationApiService.updateNotificationStatus(
              notificationId: notification.notificationId,
            );
            if (onTap != null) onTap!();
          } catch (e) {
            debugPrint('읽음 처리 실패: $e');
          }
        }

        if (notification.notificationLinkUrl.isNotEmpty) {
          context.push(notification.notificationLinkUrl);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12), // Dismissible과 결합을 위해 Padding 대신 Margin 사용
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
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
                color: isRead ? Colors.transparent : unreadColor,   // 읽었을 때 점을 아예 없애려면 Colors.transparent
              ),
            ),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.notificationContent,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isRead ? FontWeight.w400 : FontWeight.w600,
                      color: isRead ? AppColors.gray2 : AppColors.black,
                      height: 1.4,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatDate(notification.createdAt),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.gray2,
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
                color: AppColors.gray2,
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