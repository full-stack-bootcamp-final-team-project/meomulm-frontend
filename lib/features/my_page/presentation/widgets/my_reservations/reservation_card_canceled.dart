import 'package:flutter/cupertino.dart';
import 'package:meomulm_frontend/features/my_page/presentation/widgets/my_reservations/reservation_card_base.dart';
import 'package:meomulm_frontend/features/my_page/presentation/widgets/my_reservations/status_block.dart';

/// ===============================
/// 취소됨 카드
/// ===============================
class ReservationCardCanceled extends StatelessWidget {
  final String? accommodationImageUrl;
  final String hotelName;
  final String roomInfo;
  final String checkInValue;
  final String checkOutValue;

  const ReservationCardCanceled({
    super.key,
    this.accommodationImageUrl,
    required this.hotelName,
    required this.roomInfo,
    required this.checkInValue,
    required this.checkOutValue,
  });

  @override
  Widget build(BuildContext context) {
    return ReservationCardBase(
      headerLeft: StatusBlock(title: "예약취소"),
      accommodationImageUrl: accommodationImageUrl,
      hotelName: hotelName,
      roomInfo: roomInfo,
      checkInValue: checkInValue,
      checkOutValue: checkOutValue,
      isCanceled: true,
    );
  }
}