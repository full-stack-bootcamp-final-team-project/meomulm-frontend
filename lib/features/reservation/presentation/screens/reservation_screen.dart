import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/core/utils/regexp_utils.dart';
import 'package:meomulm_frontend/core/widgets/appbar/app_bar_widget.dart';
import 'package:meomulm_frontend/core/widgets/input/custom_text_field.dart';
import 'package:meomulm_frontend/core/widgets/input/custom_underline_text_field.dart';
import 'package:meomulm_frontend/core/widgets/input/text_field_widget.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/providers/accommodation_provider.dart';
import 'package:meomulm_frontend/features/reservation/presentation/providers/reservation_form_provider.dart';
import 'package:meomulm_frontend/features/reservation/presentation/providers/reservation_provider.dart';
import 'package:provider/provider.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  // TextEditingController는 UI 영역에 유지
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();

  // 버튼 활성화 상태
  bool _canSubmit = false;

  @override
  void initState() {
    super.initState();

    // 입력값 변경 시 유효성 검사
    _nameController.addListener(_validateForm);
    _emailController.addListener(_validateForm);
    _phoneController.addListener(_validateForm);
  }

  void _validateForm() {
    final isValid = RegexpUtils.validateName(_nameController.text) == null &&
        RegexpUtils.validateEmail(_emailController.text) == null &&
        RegexpUtils.validatePhone(_phoneController.text) == null;

    if (_canSubmit != isValid) {
      setState(() {
        _canSubmit = isValid;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reservationForm = context.watch<ReservationFormProvider>();
    final accommodation = context.watch<AccommodationProvider>();

    final checkInDate = accommodation.checkIn != null
        ? '${accommodation.checkIn!.year}.${accommodation.checkIn!.month.toString().padLeft(2, '0')}.${accommodation.checkIn!.day.toString().padLeft(2, '0')}'
        : '체크인 정보 없음';

    final checkOutDate = accommodation.checkOut != null
        ? '${accommodation.checkOut!.year}.${accommodation.checkOut!.month.toString().padLeft(2, '0')}.${accommodation.checkOut!.day.toString().padLeft(2, '0')}'
        : '체크아웃 정보 없음';

    // ======= 여기에 provider에서 예약 정보 가져와서 print =======
    final reservationInfo = context.watch<ReservationProvider>().reservation;
    if (reservationInfo != null) {
      print('=== ReservationScreen 예약 정보 ===');
      print('roomId: ${reservationInfo.roomId}');
      print('productName: ${reservationInfo.productName}');
      print('price: ${reservationInfo.price}');
      print('checkInfo: ${reservationInfo.checkInfo}');
      print('peopleInfo: ${reservationInfo.peopleInfo}');
      print('===============================');
    }
    // ==========================================================

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppBarWidget(
        title: TitleLabels.booking,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.xl, AppSpacing.lg, AppSpacing.xxxl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 숙소 정보
                Text(
                  accommodation.selectedAccommodationName ?? '숙소 이름 없음',
                  style: AppTextStyles.bodyXl,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  reservationInfo?.productName ?? '객실 이름 없음',
                  style: AppTextStyles.subTitle,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  reservationInfo?.peopleInfo ?? '인원 정보 없음',
                  style: AppTextStyles.bodySm,
                ),
                const SizedBox(height: AppSpacing.xl),

                // 체크인 / 체크아웃
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 108,
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: AppColors.selectedLight,
                          borderRadius:
                          BorderRadius.circular(AppBorderRadius.md),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '체크인',
                              style: AppTextStyles.bodySm,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              '$checkInDate\n${reservationInfo != null ? reservationInfo.checkInfo.split('~')[0].replaceFirst('체크인 ', '') : '체크인 정보 없음'}',
                              style: AppTextStyles.bodyMd,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Container(
                        height: 108,
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: AppColors.selectedLight,
                          borderRadius:
                          BorderRadius.circular(AppBorderRadius.md),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '체크아웃',
                              style: AppTextStyles.bodySm,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              '$checkOutDate\n${reservationInfo != null ? reservationInfo.checkInfo.split('~')[1].trimLeft().replaceFirst('체크아웃 ', '') : '체크아웃 정보 없음'}',
                              style: AppTextStyles.bodyMd,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.xxl),

                // 예약자 정보
                const Text(
                  '예약자 정보',
                  style: AppTextStyles.cardTitle,
                ),
                const SizedBox(height: AppSpacing.xl),

                CustomUnderlineTextField(
                  label: "이름",
                  isRequired: true,
                  hintText: InputMessages.emptyName,
                  controller: _nameController,
                  focusNode: _nameFocusNode,
                  validator: (value) => RegexpUtils.validateName(value),
                ),

                const SizedBox(height: AppSpacing.xl),
                CustomUnderlineTextField(
                  label: "이메일",
                  isRequired: true,
                  hintText: InputMessages.emptyEmail,
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  validator: (value) => RegexpUtils.validateEmail(value),
                ),

                const SizedBox(height: AppSpacing.xl),
                CustomUnderlineTextField(
                  label: "휴대폰 번호",
                  isRequired: true,
                  hintText: InputMessages.emptyPhone,
                  controller: _phoneController,
                  focusNode: _phoneFocusNode,
                  validator: (value) => RegexpUtils.validatePhone(value),
                ),

                const SizedBox(height: AppSpacing.xxxl),

                // 결제 정보
                const Text(
                  '결제 정보',
                  style: AppTextStyles.cardTitle,
                ),
                const SizedBox(height: AppSpacing.xl),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('객실 가격', style: AppTextStyles.bodyLg),
                    Text(
                      reservationInfo?.price ?? '가격 정보 없음',
                      style: AppTextStyles.bodyXl,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),

      // 하단 예약 버튼
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl, AppSpacing.xxs, AppSpacing.xl, AppSpacing.xl),
          child: SizedBox(
            height: AppSpacing.xxxl,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                _canSubmit ? AppColors.onPressed : Colors.grey,
              ),
              onPressed: _canSubmit
                  ? () {
                GoRouter.of(context).push('/payment');
              }
                  : null,
              child: const Text(
                ButtonLabels.bookNow,
                style: AppTextStyles.buttonLg,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
