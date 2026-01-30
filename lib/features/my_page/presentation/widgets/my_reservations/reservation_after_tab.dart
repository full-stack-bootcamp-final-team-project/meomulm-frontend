import 'package:flutter/cupertino.dart';
import 'package:meomulm_frontend/features/my_page/presentation/widgets/my_reservations/reservation_card_after.dart';
import 'package:meomulm_frontend/features/my_page/presentation/widgets/my_reservations/reservation_list.dart';

/// ===============================
/// 이용후 탭
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