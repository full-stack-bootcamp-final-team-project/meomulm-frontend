import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/router/app_router.dart';
import 'package:meomulm_frontend/core/theme/app_colors.dart';
import 'package:meomulm_frontend/core/theme/app_dimensions.dart';
import 'package:meomulm_frontend/core/theme/app_icons.dart';
import 'package:meomulm_frontend/core/theme/app_text_styles.dart';
import 'package:meomulm_frontend/core/widgets/appbar/app_bar_widget.dart';
import 'package:meomulm_frontend/core/widgets/dialogs/snack_messenger.dart';
import 'package:meomulm_frontend/features/accommodation/data/datasources/notification_api_service.dart';
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
      // 서비스 호출 시 토큰 전달
      final response = await NotificationApiService.getNotifications(
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

    // UI 제거
    final removedItem = notifications[index];
    setState(() {
      notifications.removeAt(index);
    });

    try {
      await NotificationApiService.deleteNotification(
        notificationId: id,
      );
    } catch (e) {
      // 서버 삭제 실패 시 리스트 다시 복구
      setState(() {
        notifications.insert(index, removedItem);
      });
      if (mounted) {
        SnackMessenger.showMessage(
          context,
          "알림 삭제에 실패했습니다.",
          type: ToastType.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const AppBarWidget(title: "알림 목록"),
      body: _buildBodyContent(),
    );
  }

  Widget _buildBodyContent() {
    if (isLoading) return const Center(
        child: CircularProgressIndicator(color: AppColors.black)
    );

    if (notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              AppIcons.notifications,
              size: AppIcons.sizeXxxxxl,
              color: AppColors.gray3
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              '알림 내역이 없습니다',
              style: AppTextStyles.subTitleGrey
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: loadNotifications,
      color: AppColors.black,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.lg
        ),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          NotificationResponseModel item = notifications[index];

          // 스와이프 삭제 위젯 적용
          return Dismissible(
            key: Key(item.notificationId.toString()),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              _deleteNotification(item.notificationId, index);
            },
            // 밀었을 때 뒷 배경
            background: Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.lg),
              decoration: BoxDecoration(
                color: Colors.redAccent.withOpacity(0.9),
                borderRadius: BorderRadius.circular(AppBorderRadius.xxl),
              ),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: AppSpacing.lg),
              child: const Icon(
                  AppIcons.delete,
                  color: AppColors.white,
                  size: AppIcons.sizeXl
              ),
            ),
            child: GestureDetector(
              onTap: () async {
                final linkUrl = item.notificationLinkUrl;

                if (!item.isRead) {
                  setState(() {
                    item.isRead = true;
                  });

                  NotificationApiService.updateNotificationStatus(
                    notificationId: item.notificationId,
                  ).catchError((e) => debugPrint('서버 읽음 처리 실패: $e'));
                }

                if (linkUrl != null && linkUrl.isNotEmpty) {
                  try {
                    final uri = Uri.parse(linkUrl);
                    final parsedPath = AppRouter.parseDeepLinkUri(uri);

                    if (parsedPath != null) {
                      debugPrint('알림 클릭 이동 경로: $parsedPath');
                      context.push(parsedPath);
                    } else {
                      debugPrint('해당 링크를 해석할 수 없습니다: $linkUrl');
                    }
                  } catch (e) {
                    debugPrint('URI 파싱 에러: $e');
                  }
                }
              },
              child: NotificationCard(notification: item),
            ),
          );
        },
      ),
    );
  }
}