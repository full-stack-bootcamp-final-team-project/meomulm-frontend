import 'package:flutter/cupertino.dart';
import 'package:meomulm_frontend/core/constants/ui/labels_constants.dart';
import 'package:meomulm_frontend/core/theme/app_dimensions.dart';
import 'package:meomulm_frontend/core/theme/app_input_decorations.dart';
import 'package:meomulm_frontend/core/theme/app_text_styles.dart';
import 'package:meomulm_frontend/core/widgets/dialogs/simple_modal.dart';
import 'package:meomulm_frontend/core/widgets/input/text_field_widget.dart';

/// ===============================
/// (모달) 예약 변경 다이얼로그
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
    return SimpleModal(
      onConfirm: () {
        // TODO: 버튼 클릭 시 백엔드 연결 함수 호출하기 (변경내역 저장)
      },
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "예약자 정보 변경",
            style: AppTextStyles.cardTitle.copyWith(fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: AppSpacing.xl),

          TextFieldWidget(
            label: "예약자 이름",
            decoration: AppInputDecorations.underline(
              hintText: "예약자 이름을 입력하세요.",
            ),
            errorText: "", // TODO: 유효성검사에 따라 에러메세지 반환하는 함수 구현
          ),

          const SizedBox(height: AppSpacing.xl),

          TextFieldWidget(
            label: "이메일",
            decoration: AppInputDecorations.underline(
              hintText: "이메일을 입력하세요.",
            ),
            errorText: "", // TODO: 유효성검사에 따라 에러메세지 반환하는 함수 구현
          ),
          const SizedBox(height: AppSpacing.xl),

          TextFieldWidget(
            label: "휴대폰 번호",
            decoration: AppInputDecorations.underline(
              hintText: "휴대폰 번호를 입력하세요.",
            ),
            errorText: "", // TODO: 유효성검사에 따라 에러메세지 반환하는 함수 구현
          ),
        ],
      ),
      confirmLabel: ButtonLabels.changeBooking,
    );
  }
}