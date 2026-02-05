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
import 'package:meomulm_frontend/core/widgets/dialogs/snack_messenger.dart';
import 'package:meomulm_frontend/core/widgets/input/text_field_widget.dart';
import 'package:meomulm_frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:meomulm_frontend/features/my_page/data/datasources/reservation_service.dart';
import 'package:meomulm_frontend/features/my_page/data/models/accommodation_image_model.dart';
import 'package:meomulm_frontend/features/my_page/data/models/reservation_response_model.dart';
import 'package:meomulm_frontend/features/my_page/data/models/reservation_share_model.dart';
import 'package:meomulm_frontend/features/my_page/presentation/widgets/my_reservations/reservation_after_tab.dart';
import 'package:meomulm_frontend/features/my_page/presentation/widgets/my_reservations/reservation_before_tab.dart';
import 'package:meomulm_frontend/features/my_page/presentation/widgets/my_reservations/reservation_canceled_tab.dart';
import 'package:meomulm_frontend/features/my_page/presentation/widgets/my_reservations/reservation_change_dialog.dart';
import 'package:provider/provider.dart';

/*
 * 마이페이지 - 예약내역 스크린
 */
class MyReservationsScreen extends StatefulWidget {
  // 초기 탭 인덱스 변수 추가
  final int initialTab;
  const MyReservationsScreen({super.key, this.initialTab = 0});

  @override
  State<MyReservationsScreen> createState() => _MyReservationsScreenState();
}

class _MyReservationsScreenState extends State<MyReservationsScreen>
    with SingleTickerProviderStateMixin {

  final reservationService = ReservationService();
  List<ReservationShareModel> reservations = [];
  bool isLoading = false;

  late final TabController _tabController;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: widget.initialTab);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadReservations();
      // TODO: 디버깅 후 삭제
      print('reservations count: ${reservations.length}');
      for (final r in reservations) {
        print('status=${r.status}, id=${r.reservationId}');
      }

    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // 예약 내역 조회
  Future<void> loadReservations() async{
    setState(() => isLoading = true);
    try {
      final token = context.read<AuthProvider>().token;
      if(token == null) return;

      // 예약 목록 호출
      final reservationResponse = await reservationService.loadReservations(token);
      // 예약마다 숙소 이미지 조회
      final shareModels = await Future.wait(
        reservationResponse.map((r) async {
          AccommodationImageModel? image;
          try {
            image = await reservationService.loadAccommodationImage(
              token,
              r.accommodationId,
            );
          } catch (_) {
              image = null;
          }

          return ReservationShareModel(
            reservationId: r.reservationId,
            accommodationId: r.accommodationId,
            accommodationName: r.accommodationName,
            accommodationImageUrl: image?.accommodationImageUrl,
            productName: r.productName,
            productCheckInTime: r.productCheckInTime,
            productCheckOutTime: r.productCheckOutTime,
            checkInDate: r.checkInDate,
            checkOutDate: r.checkOutDate,
            status: r.status,
          );
        })
      );
      setState(() => reservations = shareModels);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("예약 내역을 조회할 수 없습니다."),
          behavior: SnackBarBehavior.floating,
          duration: AppDurations.snackbar,
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  // 예약 취소 로직
  Future<void> cancelReservation(int reservationId) async {
    setState(() => isLoading = true);
    try {
      final token = context.read<AuthProvider>().token;
      if(token == null) return;
      final response = await reservationService.putReservation(token, reservationId);
      setState(() {
        reservations.removeWhere((r) => r.reservationId == reservationId);
      });
      SnackMessenger.showMessage(
        context,
        "예약이 취소되었습니다.",
        type: ToastType.success
      );
      context.pop(true);
    } catch (e) {
      SnackMessenger.showMessage(
        context,
        "예약 취소에 실패했습니다.",
        type: ToastType.error
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  /// 예약 취소 모달
  Future<void> _showCancelDialog(int reservationId) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return SimpleModal(
          onConfirm: () => cancelReservation(reservationId),
          content: Text(
            DialogMessages.cancelBookingContent,
            textAlign: TextAlign.center,
          ),
          confirmLabel: ButtonLabels.confirm,
        );
      },
    );
  }

  /// 예약 변경 모달
  Future<void> _showChangeDialog(int reservationId) async {
    final changed = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return ReservationChangeDialog(
          reservationId: reservationId,
        );
      },
    );

    if(changed == true) {
      loadReservations();
    }
  }

  // 상태별 예약내역
  List<ReservationShareModel> get reservationsBefore =>
      reservations.where((r) => r.status == "PAID").toList();
  List<ReservationShareModel> get reservationsAfter  =>
      reservations.where((r) => r.status == "USED").toList();
  List<ReservationShareModel> get reservationsCanceled  =>
      reservations.where((r) => r.status == "CANCELED").toList();

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
                color: AppColors.gray5,
              ),

              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    ReservationBeforeTab(
                      reservations: reservationsBefore,
                      onCancelTap: (reservationId) => _showCancelDialog(reservationId),
                      onChangeTap: (reservationId) => _showChangeDialog(reservationId),
                    ),
                    ReservationAfterTab(
                      reservations: reservationsAfter,
                      onReviewTap: (mode) {
                        if (mode == ReviewMode.write) {
                          context.push(
                            '${RoutePaths.myPage}${RoutePaths.myReviewWrite}',
                          );
                        } else {
                          context.push(
                            '${RoutePaths.myPage}${RoutePaths.myReview}',
                          );
                        }
                      },
                    ),
                    ReservationCanceledTab(
                      reservations: reservationsCanceled,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}