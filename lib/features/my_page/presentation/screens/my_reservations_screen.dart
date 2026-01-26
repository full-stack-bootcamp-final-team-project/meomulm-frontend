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


/// ===============================
/// (모달) 예약 변경 다이얼로그 위젯
/// - 사진에 맞춰: 상단 타이틀 + 닫기(X)
/// - 입력 3개: 예약자 이름/이메일/휴대폰 번호
/// - 하단 버튼: "예약 변경"
/// TODO: 위젯으로 분리
/// ===============================
class ReservationChangeDialog extends StatefulWidget {
  const ReservationChangeDialog({super.key});

  @override
  State<ReservationChangeDialog> createState() => _ReservationChangeDialogState();
}

class _ReservationChangeDialogState extends State<ReservationChangeDialog> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _onSubmit() {
    // TODO: 예약 변경 API 호출 + validation
    // 예) await reservationService.updateReservation(...);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SimpleModal(
      onConfirm: () {
        // TODO: 버튼 클릭 시 백엔드 연결 함수 호출하기 (변경내역 저장)
      },
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "예약자 정보 변경",
            style: AppTextStyles.cardTitle.copyWith(fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: AppSpacing.xl),

          TextFieldWidget(
            label: "예약자 이름",
            decoration: AppInputDecorations.underline(
              hintText: "예약자 이름을 입력하세요.",
            ),
            errorText: "", // TODO: 유효성검사에 따라 에러메세지 반환하는 함수 구현
          ),

          const SizedBox(height: AppSpacing.xl),

          TextFieldWidget(
            label: "이메일",
            decoration: AppInputDecorations.underline(
              hintText: "이메일을 입력하세요.",
            ),
            errorText: "", // TODO: 유효성검사에 따라 에러메세지 반환하는 함수 구현
          ),
          const SizedBox(height: AppSpacing.xl),

          TextFieldWidget(
            label: "휴대폰 번호",
            decoration: AppInputDecorations.underline(
              hintText: "휴대폰 번호를 입력하세요.",
            ),
            errorText: "", // TODO: 유효성검사에 따라 에러메세지 반환하는 함수 구현
          ),
        ],
      ),
      confirmLabel: ButtonLabels.changeBooking,
    );
  }
}


/// ===============================
/// 공통: 리스트 래퍼
/// TODO: 위젯으로 분리하기
/// ===============================
class ReservationList extends StatelessWidget {
  final List<Widget> children;
  final String emptyText;

  const ReservationList({
    super.key,
    required this.children,
    required this.emptyText,
  });

  @override
  Widget build(BuildContext context) {
    // 예약내역이 없는 경우
    if (children.isEmpty) {
      return ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          const SizedBox(height: AppSpacing.xl),
          Text(
            emptyText,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMd.copyWith(color: AppColors.gray2),
          ),
        ],
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: children.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.lg),
      itemBuilder: (context, index) => children[index],
    );
  }
}

/// ===============================
/// 탭 1) 이용전
/// TODO: 위젯으로 분리하기
/// ===============================
class ReservationBeforeTab extends StatelessWidget {
  final VoidCallback onCancelTap;
  final VoidCallback onChangeTap;

  const ReservationBeforeTab({
    super.key,
    required this.onCancelTap,
    required this.onChangeTap,
  });

  @override
  Widget build(BuildContext context) {
    return ReservationList(
      emptyText: '이용전 예약 내역이 없습니다.',
      children: [
        // TODO: 백엔드에서 가져온 데이터로 변경 (반복문 사용)
        ReservationCardBefore(
          hotelName: '롯데 호텔 명동',
          roomInfo: '스탠다드 룸 · 1박',
          checkInValue: '12.31 (수) 15:00',
          checkOutValue: '1.1 (목) 11:00',
          onChangeTap: onChangeTap, // ✅ 모달 호출
          onCancelTap: onCancelTap,
        ),
      ],
    );
  }
}

/// ===============================
/// 탭 2) 이용후
/// TODO: 위젯으로 분리하기
/// ===============================
enum ReviewMode { write, view }

class ReservationAfterTab extends StatelessWidget {
  final void Function(ReviewMode mode) onReviewTap;

  const ReservationAfterTab({
    super.key,
    required this.onReviewTap,
  });

  @override
  Widget build(BuildContext context) {
    return ReservationList(
      emptyText: '이용후 예약 내역이 없습니다.',
      children: [
        // TODO: 백엔드에서 가져온 데이터로 변경 (반복문 사용)
        ReservationCardAfter(
          hotelName: '롯데 호텔 명동',
          roomInfo: '스탠다드 룸 · 1박',
          checkInValue: '12.24 (수) 15:00',
          checkOutValue: '12.25 (목) 11:00',
          reviewLabel: '리뷰 입력',
          onReviewTap: () => onReviewTap(ReviewMode.write),
        ),
        ReservationCardAfter(
          hotelName: '롯데 호텔 명동',
          roomInfo: '스탠다드 룸 · 1박',
          checkInValue: '12.24 (수) 15:00',
          checkOutValue: '12.25 (목) 11:00',
          reviewLabel: '리뷰 확인',
          onReviewTap: () => onReviewTap(ReviewMode.view),
        ),
      ],
    );
  }
}

/// ===============================
/// 탭 3) 취소됨
/// TODO: 위젯으로 분리하기
/// ===============================
class ReservationCanceledTab extends StatelessWidget {
  const ReservationCanceledTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ReservationList(
      emptyText: '취소된 예약 내역이 없습니다.',
      children: const [
        // TODO: 백엔드에서 가져온 데이터로 변경 (반복문 사용)
        ReservationCardCanceled(
          hotelName: '롯데 호텔 명동',
          roomInfo: '스탠다드 룸 · 1박',
          checkInValue: '12.31 (수) 15:00',
          checkOutValue: '1.1 (목) 11:00',
        ),
      ],
    );
  }
}

/// ===============================
/// 공통 카드 베이스
/// TODO: 위젯 분리
/// ===============================
class ReservationCardBase extends StatelessWidget {
  final Widget headerLeft;

  final String hotelName;
  final String roomInfo;
  final String checkInValue;
  final String checkOutValue;

  final Widget? bottomAction;
  final bool isCanceled;

  const ReservationCardBase({
    super.key,
    required this.headerLeft,
    required this.hotelName,
    required this.roomInfo,
    required this.checkInValue,
    required this.checkOutValue,
    this.bottomAction,
    this.isCanceled = false,
  });

  @override
  Widget build(BuildContext context) {
    final labelColor = AppColors.gray3;
    final valueColor = isCanceled ? AppColors.gray2 : AppColors.black;

    return Container(
      decoration: AppCardStyles.card,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            headerLeft,
            const SizedBox(height: AppSpacing.md),
            const Divider(height: AppBorderWidth.md, thickness: AppBorderWidth.md,),
            const SizedBox(height: AppSpacing.md),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 숙소 이미지 영역
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(  // TODO: 백엔드에서 받아온 이미지로 변경하기
                    color: AppColors.gray5,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Center(
                    child: Icon(AppIcons.image, color: AppColors.gray3),
                  ),
                ),

                const SizedBox(width: AppSpacing.md),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hotelName,
                        style: AppTextStyles.cardTitle,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        roomInfo,
                        style: AppTextStyles.subTitle,
                      ),
                    ],
                  ),
                )
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            LayoutBuilder(
              builder: (context, constraints) {
                return _DateRow(
                    checkInDate: checkInValue,
                    checkOutDate: checkOutValue,
                    labelColor: labelColor,
                    valueColor: valueColor
                );
              },
            ),

            if (bottomAction != null) ...[
              const SizedBox(height: AppSpacing.lg),
              bottomAction!,
            ],
          ],
        ),
      )
    );
  }
}

/// ===============================
/// 이용전 카드
/// TODO: 위젯으로 분리하기
/// ===============================
class ReservationCardBefore extends StatelessWidget {

  final String hotelName;
  final String roomInfo;
  final String checkInValue;
  final String checkOutValue;

  final VoidCallback onChangeTap;
  final VoidCallback onCancelTap;

  const ReservationCardBefore({
    super.key,
    required this.hotelName,
    required this.roomInfo,
    required this.checkInValue,
    required this.checkOutValue,
    required this.onChangeTap,
    required this.onCancelTap,
  });

  @override
  Widget build(BuildContext context) {
    return ReservationCardBase(
      headerLeft: _StatusBlock(title: "예약확정"),
      hotelName: hotelName,
      roomInfo: roomInfo,
      checkInValue: checkInValue,
      checkOutValue: checkOutValue,
      bottomAction: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 360;  // 설정되어 있는 mobile 브레이크포인트로 설정하면 이상해서 일단 이렇게 설정함.

          Widget changeBtn() => OptionButton(
              // label: ButtonLabels.changeBooking, -> 현재 공통 상수에는 "예약 변경"으로 되어 있어서 일단 임시로 바꿔둠
              label: "예약자 정보 변경",
              onPressed: onChangeTap,
          );

          Widget cancelBtn() => OptionCancelButton(
              label: ButtonLabels.cancelBooking,
              onPressed: onCancelTap,
          );

          if (isNarrow) {
            return Column(
              children: [
                changeBtn(),
                const SizedBox(height: AppSpacing.md),
                cancelBtn(),
              ],
            );
          }

          return Row(
            children: [
              Expanded(child: changeBtn()),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: cancelBtn()),
            ],
          );
        },
      ),
    );
  }
}

/// ===============================
/// 이용후 카드 (리뷰 입력/확인)
/// TODO: 위젯으로 분리
/// ===============================
class ReservationCardAfter extends StatelessWidget {
  final String hotelName;
  final String roomInfo;
  final String checkInValue;
  final String checkOutValue;

  final String reviewLabel;
  final VoidCallback onReviewTap;

  const ReservationCardAfter({
    super.key,
    required this.hotelName,
    required this.roomInfo,
    required this.checkInValue,
    required this.checkOutValue,
    required this.reviewLabel,
    required this.onReviewTap,
  });

  @override
  Widget build(BuildContext context) {
    return ReservationCardBase(
      headerLeft: _StatusBlock(title: "이용완료"),
      hotelName: hotelName,
      roomInfo: roomInfo,
      checkInValue: checkInValue,
      checkOutValue: checkOutValue,
      bottomAction: SizedBox(
        width: double.infinity,
        child: OptionButton(
            label: ButtonLabels.writeReview,
            onPressed: onReviewTap
        ),
      ),
    );
  }
}

/// ===============================
/// 취소됨 카드
/// TODO: 위젯으로 분리
/// ===============================
class ReservationCardCanceled extends StatelessWidget {
  final String hotelName;
  final String roomInfo;
  final String checkInValue;
  final String checkOutValue;

  const ReservationCardCanceled({
    super.key,
    required this.hotelName,
    required this.roomInfo,
    required this.checkInValue,
    required this.checkOutValue,
  });

  @override
  Widget build(BuildContext context) {
    return ReservationCardBase(
      headerLeft: _StatusBlock(title: "예약취소"),
      hotelName: hotelName,
      roomInfo: roomInfo,
      checkInValue: checkInValue,
      checkOutValue: checkOutValue,
      isCanceled: true,
    );
  }
}


/// ===============================
/// 예약 상태 블록
/// TODO: 위젯으로 분리
/// ===============================
class _StatusBlock extends StatelessWidget {
  final String title;

  const _StatusBlock({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    if(title == "예약확정") {
      return _StatusBlockStyle(
        title: title,
        backgroundColor: AppColors.selectedLight,
        textColor: AppColors.menuSelected,
      );
    }

    if(title == "이용완료") {
      return _StatusBlockStyle(
        title: title,
        backgroundColor: AppColors.gray4,
        textColor: AppColors.gray2,
      );
    }

    return _StatusBlockStyle(
      title: title,
      backgroundColor: AppColors.cancelledLight,
      textColor: AppColors.cancelled,
    );
  }
}

/// ===============================
/// 예약 상태 블록 공통 스타일
/// TODO: 위젯으로 분리
/// ===============================
class _StatusBlockStyle extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final Color textColor;

  const _StatusBlockStyle({
    required this.title,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 65,
      height: 27,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppBorderRadius.xs),
        color: backgroundColor,
      ),
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: AppTextStyles.buttonSm.copyWith(color: textColor),
        ),
      ),
    );
  }
}


/// ===============================
/// 체크인/체크아웃 라인
/// TODO: 위젯으로 분리
/// ===============================
class _DateRow extends StatelessWidget {
  final String checkInDate;
  final String checkOutDate;
  final Color labelColor;
  final Color valueColor;

  const _DateRow({
    required this.checkInDate,
    required this.checkOutDate,
    required this.labelColor,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "체크인",
                  style: AppTextStyles.bodyXs.copyWith(color: labelColor),
                ),
                Text(
                  checkInDate,
                  style: AppTextStyles.bodyMd.copyWith(color: valueColor),
                  textAlign: TextAlign.right,
                )
              ],
            ),
          ),


          const SizedBox(width: AppSpacing.md),
          const SizedBox(
            height: AppSpacing.xxl,
            child: VerticalDivider(
              width: AppBorderWidth.md,
              thickness: AppBorderWidth.md,
              color: AppColors.gray3,
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "체크아웃",
                  style: AppTextStyles.bodyXs.copyWith(color: labelColor),
                ),
                Text(
                  checkOutDate,
                  style: AppTextStyles.bodyMd.copyWith(color: valueColor),
                  textAlign: TextAlign.right,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}