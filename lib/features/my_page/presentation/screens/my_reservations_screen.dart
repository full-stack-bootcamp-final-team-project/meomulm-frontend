import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/constants/paths/route_paths.dart';

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
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      '예약을 취소하시겠습니까?\n취소 후에는 다시 되돌릴 수 없습니다.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: 160,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8E86C9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          '확인',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 6,
                top: 6,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, size: 18),
                  splashRadius: 18,
                ),
              ),
            ],
          ),
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
        return const Dialog(
          backgroundColor: Color(0xFFF5F6FF), // 사진처럼 살짝 푸른 톤
          insetPadding: EdgeInsets.symmetric(horizontal: 30),
          child: ReservationChangeDialog(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final maxWidth = w >= 600 ? w : double.infinity;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.go('/'), // TODO: 추후 마이페이지로 변경
        ),
        title: const Text(
          '예약 내역',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(44),
          child: Column(
            children: [
              TabBar(
                controller: _tabController,
                labelColor: const Color(0xFF009DFF),
                unselectedLabelColor: const Color(0xFF8B8B8B),
                indicatorColor: const Color(0xFF009DFF),
                indicatorWeight: 2,
                tabs: const [
                  Tab(text: '이용전'),
                  Tab(text: '이용후'),
                  Tab(text: '취소됨'),
                ],
              ),
              const Divider(height: 1, thickness: 1, color: Color(0xFFE5E5E5)),
            ],
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
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
      ),
    );
  }
}

/// ===============================
/// (모달) 예약 변경 다이얼로그 위젯
/// - 사진에 맞춰: 상단 타이틀 + 닫기(X)
/// - 입력 3개: 예약자 이름/이메일/휴대폰 번호
/// - 하단 버튼: "예약 변경"
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
    // ✅ Dialog의 크기 조절: 여기 width/constraints를 바꾸시면 됩니다.
    // - width 값을 키우면 더 큰 팝업
    // - maxWidth를 줄이면 더 작은 팝업
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Container(
        padding: const EdgeInsets.fromLTRB(25, 25, 25, 25),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F6FF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 상단 타이틀 영역
                const SizedBox(height: 4),
                const Text(
                  '예약 변경',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 25),

                // 입력 폼
                _UnderlineField(
                  label: '예약자 이름',
                  hint: '예약자 이름을 입력하세요.',
                  controller: _nameCtrl,
                ),
                const SizedBox(height: 18),
                _UnderlineField(
                  label: '이메일',
                  hint: '이메일을 입력하세요.',
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 18),
                _UnderlineField(
                  label: '휴대폰 번호',
                  hint: '휴대폰 번호를 입력하세요.',
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                ),

                const SizedBox(height: 30),

                // 버튼
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: _onSubmit,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color(0xFF8E86C9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      '예약 변경',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // 우측 상단 닫기(X)
            Positioned(
              right: 0,
              top: 0,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, size: 18, color: Colors.black),
                splashRadius: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ===============================
/// (모달 내부) 라벨 + underline TextField
/// ===============================
class _UnderlineField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  const _UnderlineField({
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF9E9E9E),
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            isDense: true,
            hintText: hint,
            hintStyle: const TextStyle(
              fontSize: 13,
              color: Color(0xFFBDBDBD),
              fontWeight: FontWeight.w600,
            ),
            border: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 1),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 1),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFBDBDBD), width: 1),
            ),
          ),
        ),
      ],
    );
  }
}

/// ===============================
/// 공통: 리스트 래퍼
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
    if (children.isEmpty) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 24),
          Text(
            emptyText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF8B8B8B),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: children.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, index) => children[index],
    );
  }
}

/// ===============================
/// 탭 1) 이용전
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
        ReservationCardBefore(
          statusTitle: '예약확정',
          statusSubTitle: '1일 2시간 30분 뒤 입실 가능',
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
/// ===============================
class ReservationCanceledTab extends StatelessWidget {
  const ReservationCanceledTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ReservationList(
      emptyText: '취소된 예약 내역이 없습니다.',
      children: const [
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
    final labelColor =
    isCanceled ? const Color(0xFF9F9F9F) : const Color(0xFF8B8B8B);
    final valueColor = isCanceled ? const Color(0xFF9F9F9F) : Colors.black;

    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Color(0x558B8B8B)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            headerLeft,
            const SizedBox(height: 10),
            const Divider(height: 1, thickness: 1),
            const SizedBox(height: 10),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Center(
                    child: Icon(Icons.image, color: Color(0xFF9E9E9E)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hotelName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        roomInfo,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF8B8B8B),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 360;

                if (isNarrow) {
                  return Column(
                    children: [
                      _DateRow(
                        label: '체크인',
                        value: checkInValue,
                        labelColor: labelColor,
                        valueColor: valueColor,
                      ),
                      const SizedBox(height: 8),
                      _DateRow(
                        label: '체크아웃',
                        value: checkOutValue,
                        labelColor: labelColor,
                        valueColor: valueColor,
                      ),
                    ],
                  );
                }

                return Row(
                  children: [
                    Expanded(
                      child: _DateRow(
                        label: '체크인',
                        value: checkInValue,
                        labelColor: labelColor,
                        valueColor: valueColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const SizedBox(
                      height: 34,
                      child: VerticalDivider(
                        width: 1,
                        thickness: 1,
                        color: Color(0xFF8B8B8B),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _DateRow(
                        label: '체크아웃',
                        value: checkOutValue,
                        labelColor: labelColor,
                        valueColor: valueColor,
                      ),
                    ),
                  ],
                );
              },
            ),

            if (bottomAction != null) ...[
              const SizedBox(height: 14),
              bottomAction!,
            ],
          ],
        ),
      ),
    );
  }
}

/// ===============================
/// 이용전 카드
/// ===============================
class ReservationCardBefore extends StatelessWidget {
  final String statusTitle;
  final String statusSubTitle;

  final String hotelName;
  final String roomInfo;
  final String checkInValue;
  final String checkOutValue;

  final VoidCallback onChangeTap;
  final VoidCallback onCancelTap;

  const ReservationCardBefore({
    super.key,
    required this.statusTitle,
    required this.statusSubTitle,
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
      headerLeft: _StatusBlock(title: statusTitle, subTitle: statusSubTitle),
      hotelName: hotelName,
      roomInfo: roomInfo,
      checkInValue: checkInValue,
      checkOutValue: checkOutValue,
      bottomAction: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 360;

          Widget changeBtn() => SizedBox(
            width: double.infinity,
            height: 36,
            child: ElevatedButton(
              onPressed: onChangeTap,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: const Color(0xFFD2D2D2),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                '예약 변경',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          );

          Widget cancelBtn() => SizedBox(
            width: double.infinity,
            height: 36,
            child: ElevatedButton(
              onPressed: onCancelTap,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: const Color(0xFFFFBEBE),
                foregroundColor: const Color(0xFFFF2A2A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                '예약 취소',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          );

          if (isNarrow) {
            return Column(
              children: [
                changeBtn(),
                const SizedBox(height: 10),
                cancelBtn(),
              ],
            );
          }

          return Row(
            children: [
              Expanded(child: changeBtn()),
              const SizedBox(width: 12),
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
      headerLeft: const Text(
        '이용완료',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: Colors.black,
        ),
      ),
      hotelName: hotelName,
      roomInfo: roomInfo,
      checkInValue: checkInValue,
      checkOutValue: checkOutValue,
      bottomAction: SizedBox(
        width: double.infinity,
        height: 36,
        child: ElevatedButton(
          onPressed: onReviewTap,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: const Color(0xFFD2D2D2),
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            reviewLabel,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}

/// ===============================
/// 취소됨 카드
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
      headerLeft: const Text(
        '예약취소',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: Color(0xFFFF2A2A),
        ),
      ),
      hotelName: hotelName,
      roomInfo: roomInfo,
      checkInValue: checkInValue,
      checkOutValue: checkOutValue,
      isCanceled: true,
    );
  }
}

/// 이용전 상태 블록
class _StatusBlock extends StatelessWidget {
  final String title;
  final String subTitle;

  const _StatusBlock({
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subTitle,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF009DFF),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// 체크인/체크아웃 라인
class _DateRow extends StatelessWidget {
  final String label;
  final String value;
  final Color labelColor;
  final Color valueColor;

  const _DateRow({
    required this.label,
    required this.value,
    required this.labelColor,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: labelColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              color: valueColor,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}