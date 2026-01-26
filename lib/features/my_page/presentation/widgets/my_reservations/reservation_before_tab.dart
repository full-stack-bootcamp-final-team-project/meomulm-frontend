import 'package:flutter/cupertino.dart';
import 'package:meomulm_frontend/features/my_page/presentation/widgets/my_reservations/reservation_card_before.dart';
import 'package:meomulm_frontend/features/my_page/presentation/widgets/my_reservations/reservation_list.dart';

/// ===============================
/// 이용전 탭
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