import 'package:flutter/cupertino.dart';
import 'package:meomulm_frontend/features/my_page/data/models/reservation_share_model.dart';
import 'package:meomulm_frontend/features/my_page/presentation/widgets/my_reservations/reservation_card_canceled.dart';
import 'package:meomulm_frontend/features/my_page/presentation/widgets/my_reservations/reservation_list.dart';

/// ===============================
/// 취소됨 탭
/// ===============================
class ReservationCanceledTab extends StatelessWidget {
  final List<ReservationShareModel> reservations;
  const ReservationCanceledTab({
    super.key,
    required this.reservations
  });

  @override
  Widget build(BuildContext context) {
    return ReservationList(
      emptyText: '취소된 예약 내역이 없습니다.',
      children: reservations.map((r) {
        return ReservationCardCanceled(
          accommodationImageUrl: r.accommodationImageUrl,
          hotelName: r.accommodationName,
          roomInfo: r.subtitle,
          checkInValue: '${r.checkInText} ${r.productCheckInTimeOnly}',
          checkOutValue: '${r.checkOutText} ${r.productCheckOutTimeOnly}',
        );
      }).toList(),
    );
  }
}