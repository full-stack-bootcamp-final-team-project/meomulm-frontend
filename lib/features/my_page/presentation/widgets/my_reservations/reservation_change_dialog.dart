import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/constants/config/app_config.dart';
import 'package:meomulm_frontend/core/constants/ui/labels_constants.dart';
import 'package:meomulm_frontend/core/constants/ui/messages_constants.dart';
import 'package:meomulm_frontend/core/theme/app_dimensions.dart';
import 'package:meomulm_frontend/core/theme/app_input_decorations.dart';
import 'package:meomulm_frontend/core/theme/app_input_styles.dart';
import 'package:meomulm_frontend/core/theme/app_text_styles.dart';
import 'package:meomulm_frontend/core/utils/regexp_utils.dart';
import 'package:meomulm_frontend/core/widgets/dialogs/simple_modal.dart';
import 'package:meomulm_frontend/core/widgets/input/text_field_widget.dart';
import 'package:meomulm_frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:meomulm_frontend/features/my_page/data/datasources/reservation_service.dart';
import 'package:meomulm_frontend/features/my_page/data/models/reservation_update_request_model.dart';
import 'package:provider/provider.dart';

/// ===============================
/// (모달) 예약 변경 다이얼로그
/// ===============================
class ReservationChangeDialog extends StatefulWidget {
  final int reservationId;
  const ReservationChangeDialog({
    super.key,
    required this.reservationId
  });

  @override
  State<ReservationChangeDialog> createState() => _ReservationChangeDialogState();
}

class _ReservationChangeDialogState extends State<ReservationChangeDialog> {
  bool isLoading = false;
  bool isSubmittable = false;
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();


  @override
  void initState() {
    super.initState();
    
    _nameCtrl.addListener(submitCheck);
    _emailCtrl.addListener(submitCheck);
    _phoneCtrl.addListener(submitCheck);
  }

  @override
  void dispose() {
    _nameCtrl.removeListener(submitCheck);
    _emailCtrl.removeListener(submitCheck);
    _phoneCtrl.removeListener(submitCheck);
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  // TODO: 유효성 검사를 통해 submittable 검증하는 함수
  void submitCheck () {
    final nameResult = RegexpUtils.validateName(_nameCtrl.text.trim());
    final emailResult = RegexpUtils.validateEmail(_emailCtrl.text.trim());
    final phoneResult = RegexpUtils.validatePhone(_phoneCtrl.text.trim());
    bool allPassed = nameResult == null && emailResult == null && phoneResult == null;
    
    if(isSubmittable != allPassed) {
      setState(() => isSubmittable = allPassed);
    }
  }

  Future<void> _onSubmit() async {
    if(!isSubmittable) return;
    
    // 검증 성공 시 로딩
    setState(() => isLoading = true);
    
    final request = ReservationUpdateRequestModel(
        reservationId: widget.reservationId,
        bookerName: _nameCtrl.text.trim(),
        bookerEmail: _emailCtrl.text.trim(),
        bookerPhone: _phoneCtrl.text.trim(),
    );

    try {
      final reservationService = ReservationService();
      final token = context.read<AuthProvider>().token;
      if(token == null) {
        return;
      }
      final result = await reservationService.updateReservation(token, request);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("예약자 정보가 변경되었습니다."),
          behavior: SnackBarBehavior.floating,
          duration: AppDurations.snackbar,
        ),
      );
      context.pop(true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("예약자 정보 변경에 실패했습니다."))
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SimpleModal(
      onConfirm: _onSubmit,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "예약자 정보 변경",
            style: AppTextStyles.cardTitle.copyWith(fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: AppSpacing.xl),

          TextFieldWidget(
            controller: _nameCtrl,
            label: "예약자 이름",
            style: AppInputStyles.underline,
              hintText: "예약자 이름을 입력하세요.",
            validator: (name) => RegexpUtils.validateName(name),
          ),

          const SizedBox(height: AppSpacing.xl),

          TextFieldWidget(
            controller: _emailCtrl,
            label: "이메일",
            style: AppInputStyles.underline,
              hintText: "이메일을 입력하세요.",
            keyboardType: TextInputType.emailAddress,
            validator: (email) => RegexpUtils.validateEmail(email),
          ),
          const SizedBox(height: AppSpacing.xl),

          TextFieldWidget(
            controller: _phoneCtrl,
            label: "휴대폰 번호",
            style: AppInputStyles.underline,
              hintText: "휴대폰 번호를 입력하세요.",
            validator: (phone) => RegexpUtils.validatePhone(phone),
          ),
        ],
      ),
      confirmLabel: ButtonLabels.changeBooking,
    );
  }
}