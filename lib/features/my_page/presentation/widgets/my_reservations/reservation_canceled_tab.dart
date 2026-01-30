import 'package:flutter/cupertino.dart';
import 'package:meomulm_frontend/features/my_page/presentation/widgets/my_reservations/reservation_card_canceled.dart';
import 'package:meomulm_frontend/features/my_page/presentation/widgets/my_reservations/reservation_list.dart';

/// ===============================
/// 취소됨 탭
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