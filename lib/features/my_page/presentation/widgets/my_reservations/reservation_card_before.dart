import 'package:flutter/cupertino.dart';
import 'package:meomulm_frontend/core/constants/ui/labels_constants.dart';
import 'package:meomulm_frontend/core/theme/app_dimensions.dart';
import 'package:meomulm_frontend/core/widgets/buttons/button_widgets.dart';
import 'package:meomulm_frontend/features/my_page/presentation/widgets/my_reservations/reservation_card_base.dart';
import 'package:meomulm_frontend/features/my_page/presentation/widgets/my_reservations/status_block.dart';


/// ===============================
/// 이용전 카드
/// ===============================
class ReservationCardBefore extends StatelessWidget {

  final String hotelName;
  final String? accommodationImageUrl;
  final String roomInfo;
  final String checkInValue;
  final String checkOutValue;

  final VoidCallback onChangeTap;
  final VoidCallback onCancelTap;

  const ReservationCardBefore({
    super.key,
    required this.hotelName,
    this.accommodationImageUrl,
    required this.roomInfo,
    required this.checkInValue,
    required this.checkOutValue,
    required this.onChangeTap,
    required this.onCancelTap,
  });

  @override
  Widget build(BuildContext context) {
    return ReservationCardBase(
      headerLeft: StatusBlock(title: "예약확정"),
      accommodationImageUrl: accommodationImageUrl,
      hotelName: hotelName,
      roomInfo: roomInfo,
      checkInValue: checkInValue,
      checkOutValue: checkOutValue,
      bottomAction: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 300;  // 설정되어 있는 mobile 브레이크포인트로 설정하면 이상해서 일단 이렇게 설정함.

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
                Row(
                  children: [Expanded(child: changeBtn())],
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [Expanded(child: cancelBtn())],
                )
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