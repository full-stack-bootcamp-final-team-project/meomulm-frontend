import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/widgets/appbar/app_bar_widget.dart';
import 'package:meomulm_frontend/features/accommodation/data/datasources/notification_service.dart';
import 'package:meomulm_frontend/features/accommodation/data/models/notification_response_model.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/notification_list_widgets/notification_card.dart';
import 'package:meomulm_frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:provider/provider.dart';

/*
"예약 완료! [숙소명] 예약이 확정되었습니다."
"[숙소명] 예약이 정상적으로 취소되었습니다."
"내일은 [숙소명] 체크인 날입니다!"
"숙소는 어떠셨나요? 리뷰를 남겨주세요!"
"고객님의 생일을 진심으로 축하합니다!"
  "문의하신 답변이 등록되었습니다. 바로 확인해보세요."
 */

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  List<NotificationResponseModel> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    final authProvider = context.read<AuthProvider>();

    if (!authProvider.isLoggedIn) {
      setState(() {
        isLoading = false;
        notifications = [];
      });
      return;
    }

    setState(() => isLoading = true);

    try {
      // 1. 서비스 호출 시 토큰 전달
      final response = await NotificationService.getNotifications(
        token: authProvider.token ?? '',
      );

      setState(() {
        // 최신순 정렬
        notifications = response.reversed.toList();
        isLoading = false;
      });
    } catch (e) {
      debugPrint('데이터 로드 실패: $e');
      setState(() {
        notifications = [];
        isLoading = false;
      });
    }
  }

  // 알림 삭제 로직
  Future<void> _deleteNotification(int id, int index) async {
    final authProvider = context.read<AuthProvider>();

    // UI 먼저 제거
    final removedItem = notifications[index];
    setState(() {
      notifications.removeAt(index);
    });

    try {
      await NotificationService.deleteNotification(
        notificationId: id,
      );
    } catch (e) {
      // 서버 삭제 실패 시 리스트에 다시 복구
      setState(() {
        notifications.insert(index, removedItem);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('알림 삭제에 실패했습니다.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: const AppBarWidget(title: "알림 목록"),
      body: _buildBodyContent(),
    );
  }

  Widget _buildBodyContent() {
    if (isLoading) return const Center(
        child: CircularProgressIndicator(color: Colors.black)
    );

    if (notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none_rounded,
              size: 64,
              color: Colors.grey[300]
            ),
            const SizedBox(height: 16),
            const Text(
              '알림 내역이 없습니다',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey
              )
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: loadNotifications,
      color: Colors.black,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final item = notifications[index];

          // 스와이프 삭제 위젯 적용
          return Dismissible(
            key: Key(item.notificationId.toString()),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              _deleteNotification(item.notificationId, index);
            },
            // 밀었을 때 뒷 배경
            background: Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.redAccent.withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(
                Icons.delete_sweep_rounded,
                color: Colors.white,
                size: 28
              ),
            ),
            child: NotificationCard(notification: item),
          );
        },
      ),
    );
  }
}