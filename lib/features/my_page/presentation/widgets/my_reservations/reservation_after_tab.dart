import 'package:flutter/cupertino.dart';
import 'package:meomulm_frontend/features/my_page/data/models/reservation_share_model.dart';
import 'package:meomulm_frontend/features/my_page/presentation/widgets/my_reservations/reservation_card_after.dart';
import 'package:meomulm_frontend/features/my_page/presentation/widgets/my_reservations/reservation_list.dart';

/// ===============================
/// 이용후 탭
/// ===============================
enum ReviewMode { write, view }

class ReservationAfterTab extends StatelessWidget {
  final List<ReservationShareModel> reservations;
  final void Function(ReviewMode mode, ReservationShareModel resevation) onReviewTap;

  const ReservationAfterTab({
    super.key,
    required this.reservations,
    required this.onReviewTap,
  });

  @override
  Widget build(BuildContext context) {
    return ReservationList(
      emptyText: '이용후 예약 내역이 없습니다.',
      children: reservations.map((r) {
        return ReservationCardAfter(
          accommodationImageUrl: r.accommodationImageUrl,
          hotelName: r.accommodationName,
          roomInfo: r.subtitle,
          checkInValue: '${r.checkInText} ${r.productCheckInTimeOnly}',
          checkOutValue: '${r.checkOutText} ${r.productCheckOutTimeOnly}',
          reviewLabel: '리뷰 입력',
          onReviewTap: () => onReviewTap(ReviewMode.write, r),
        );
      }).toList(),
    );
  }
}