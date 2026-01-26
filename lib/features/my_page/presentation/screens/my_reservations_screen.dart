import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/core/constants/paths/route_paths.dart';
import 'package:meomulm_frontend/core/theme/app_colors.dart';
import 'package:meomulm_frontend/core/theme/app_dimensions.dart';
import 'package:meomulm_frontend/core/theme/app_input_decorations.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/core/widgets/appbar/app_bar_widget.dart';
import 'package:meomulm_frontend/core/widgets/buttons/button_widgets.dart';
import 'package:meomulm_frontend/core/widgets/dialogs/simple_modal.dart';
import 'package:meomulm_frontend/core/widgets/input/text_field_widget.dart';
import 'package:meomulm_frontend/features/my_page/presentation/widgets/my_reservations/reservation_after_tab.dart';
import 'package:meomulm_frontend/features/my_page/presentation/widgets/my_reservations/reservation_before_tab.dart';
import 'package:meomulm_frontend/features/my_page/presentation/widgets/my_reservations/reservation_canceled_tab.dart';
import 'package:meomulm_frontend/features/my_page/presentation/widgets/my_reservations/reservation_card_canceled.dart';
import 'package:meomulm_frontend/features/my_page/presentation/widgets/my_reservations/reservation_change_dialog.dart';

/*
 * 마이페이지 - 예약내역 스크린
 */
class MyReservationsScreen extends StatefulWidget {
  const MyReservationsScreen({super.key});

  @override
  State<MyReservationsScreen> createState() => _MyReservationsScreenState();
}

class _MyReservationsScreenState extends State<MyReservationsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// ✅ 예약 취소 모달(기존)
  Future<void> _showCancelDialog() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return SimpleModal(
            onConfirm: () {
              // TODO: 버튼 클릭 시 예약 취소하는 함수 구현 후 호출 (백엔드 연결)
            },
            content: Text(
              DialogMessages.cancelBookingContent,
              textAlign: TextAlign.center,
            ),
            confirmLabel: ButtonLabels.confirm,
        );
      },
    );
  }

  /// ✅ 예약 변경 모달(사진 스타일)
  Future<void> _showChangeDialog() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return ReservationChangeDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final maxWidth = w >= 600 ? w : double.infinity;

    return Scaffold(
      appBar: AppBarWidget(title: TitleLabels.myBookings),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Column(
            children: [
              TabBar(
                controller: _tabController,
                labelColor: AppColors.menuSelected,
                unselectedLabelColor: AppColors.gray3,
                indicatorColor: AppColors.menuSelected,
                indicatorWeight: 2,
                tabs: const [
                  Tab(text: '이용전'),
                  Tab(text: '이용후'),
                  Tab(text: '취소됨'),
                ],
              ),

              const Divider(
                  height: AppBorderWidth.md,
                  thickness: AppBorderWidth.sm,
                  color: AppColors.gray5
              ),

              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    ReservationBeforeTab(
                      onCancelTap: _showCancelDialog,
                      onChangeTap: _showChangeDialog, // ✅ 여기서 예약 변경 모달 호출
                    ),
                    ReservationAfterTab(
                      onReviewTap: (mode) {
                        if (mode == ReviewMode.write) {
                          // TODO: 리뷰 입력 페이지로 이동
                          context.push('${RoutePaths.myPage}${RoutePaths.myReviewWrite}');
                        } else {
                          // TODO: 리뷰 확인 페이지로 이동
                          context.push('${RoutePaths.myPage}${RoutePaths.myReview}');
                        }
                      },
                    ),
                    const ReservationCanceledTab(),
                  ],
                ),
              ),
            ],
          )
        ),
      ),
    );
  }
}