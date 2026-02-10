import 'package:flutter/cupertino.dart';
import 'package:meomulm_frontend/features/my_page/data/models/reservation_share_model.dart';
import 'package:meomulm_frontend/features/my_page/presentation/widgets/my_reservations/reservation_card_before.dart';
import 'package:meomulm_frontend/features/my_page/presentation/widgets/my_reservations/reservation_list.dart';

/// ===============================
/// 이용전 탭
/// ===============================
class ReservationBeforeTab extends StatelessWidget {
  final List<ReservationShareModel> reservations;
  final void Function(int reservationId) onCancelTap;  // 상위로 선택한 카드의 reservationId 보내기
  final void Function(int reservationId) onChangeTap;

  const ReservationBeforeTab({
    super.key,
    required this.reservations,
    required this.onCancelTap,
    required this.onChangeTap,
  });

  @override
  Widget build(BuildContext context) {
    return ReservationList(
      emptyText: '이용전 예약 내역이 없습니다.',
      children: reservations.map((r) {
        return ReservationCardBefore(
          hotelName: r.accommodationName,
          accommodationImageUrl: r.accommodationImageUrl,
          roomInfo: r.subtitle,
          checkInValue: '${r.checkInText} ${r.productCheckInTimeOnly}',
          checkOutValue: '${r.checkOutText} ${r.productCheckOutTimeOnly}',
          onChangeTap: () => onChangeTap(r.reservationId),
          onCancelTap: () => onCancelTap(r.reservationId),
        );
      }).toList(),
    );
  }
}