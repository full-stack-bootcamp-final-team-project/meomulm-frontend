import 'package:flutter/cupertino.dart';
import 'package:meomulm_frontend/core/constants/ui/labels_constants.dart';
import 'package:meomulm_frontend/core/widgets/buttons/button_widgets.dart';
import 'package:meomulm_frontend/features/my_page/presentation/widgets/my_reservations/reservation_card_base.dart';
import 'package:meomulm_frontend/features/my_page/presentation/widgets/my_reservations/status_block.dart';

/// ===============================
/// 예약 스크린
/// 이용후 카드 (리뷰 입력/확인)
/// ===============================

class ReservationCardAfter extends StatelessWidget {
  final String? accommodationImageUrl;
  final String hotelName;
  final String roomInfo;
  final String checkInValue;
  final String checkOutValue;

  final String reviewLabel;
  final VoidCallback onReviewTap;

  const ReservationCardAfter({
    super.key,
    this.accommodationImageUrl,
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
      headerLeft: StatusBlock(title: "이용완료"),
      accommodationImageUrl: accommodationImageUrl,
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