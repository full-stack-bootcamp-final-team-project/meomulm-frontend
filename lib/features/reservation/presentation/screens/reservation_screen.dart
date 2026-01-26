import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/core/widgets/appbar/app_bar_widget.dart';
import 'package:meomulm_frontend/core/widgets/input/text_field_widget.dart';
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

  @override
  void initState() {
    super.initState();
    // 입력 변경시 Provider에 전달
    _nameController.addListener(() {
      context.read<ReservationProvider>().setName(_nameController.text);
    });
    _emailController.addListener(() {
      context.read<ReservationProvider>().setEmail(_emailController.text);
    });
    _phoneController.addListener(() {
      context.read<ReservationProvider>().setPhone(_phoneController.text);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reservation = context.watch<ReservationProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppBarWidget(
        title: TitleLabels.booking,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.xl, AppSpacing.lg, AppSpacing.xxxl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [


                // 숙소 정보
                const Text(
                  '그랜드 호스텔 LDK 명동',
                  style: AppTextStyles.cardTitle,
                ),
                const SizedBox(height: AppSpacing.sm),
                const Text(
                  '프리미어 패밀리 트윈',
                  style: AppTextStyles.subTitle ,
                ),
                const SizedBox(height: AppSpacing.xs),
                const Text(
                  '기준 3인 / 최대 3인',
                  style: AppTextStyles.bodySm,
                ),
                const SizedBox(height: AppSpacing.xl),

                // 체크인 / 체크아웃
                // 체크인 / 체크아웃
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 108,
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: AppColors.selectedLight, // 배경 색
                          borderRadius: BorderRadius.circular(AppBorderRadius.md),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              '체크인',
                              style: AppTextStyles.bodySm,
                            ),
                            SizedBox(height: AppSpacing.sm),
                            Text(
                              '2025.12.30 (화)\n15:00',
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
                          color: AppColors.selectedLight, // 배경 색
                          borderRadius: BorderRadius.circular(AppBorderRadius.md),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              '체크아웃',
                              style: AppTextStyles.bodySm,
                            ),
                            SizedBox(height: AppSpacing.sm),
                            Text(
                              '2026.12.31 (수)\n11:00',
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

                // Label
                Text('예약자 이름', style: AppTextStyles.inputLabel),
                const SizedBox(height: AppSpacing.sm),

                // 입력창
                TextFieldWidget(
                  controller: _nameController,
                  style: AppInputStyles.underline,
                  decoration: AppInputDecorations.underline(
                    hintText: InputMessages.emptyName,
                    errorText: reservation.nameError,
                  ),
                  keyboardType: TextInputType.text,
                ),

                const SizedBox(height: AppSpacing.xl),

                // Label
                Text('이메일', style: AppTextStyles.inputLabel),
                const SizedBox(height: AppSpacing.sm),

                // 입력창
                TextFieldWidget(
                  controller: _emailController,
                  style: AppInputStyles.underline,
                  decoration: AppInputDecorations.underline(
                    hintText: InputMessages.emptyEmail,
                    errorText: reservation.emailError,
                  ),
                  keyboardType: TextInputType.text,
                ),

                const SizedBox(height: AppSpacing.xl),


                // 휴대번호
                // Label
                Text('휴대폰 번호', style: AppTextStyles.inputLabel),
                const SizedBox(height: AppSpacing.sm),

                // 입력창
                TextFieldWidget(
                  controller: _phoneController,
                  style: AppInputStyles.underline,
                  decoration: AppInputDecorations.underline(
                    hintText: InputMessages.emptyPhone,
                    errorText: reservation.phoneError,
                  ),
                  keyboardType: TextInputType.text,
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
                  children: const [
                    Text('객실 가격(1박)', style: AppTextStyles.bodyLg),
                    Text(
                      '153,000원',
                      style:AppTextStyles.bodyLg,
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
          padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.xxs, AppSpacing.xl, AppSpacing.xl),
          child: SizedBox(
            height: AppSpacing.xxxl,
            child: ElevatedButton(
              style: AppButtonStyles.globalButtonStyle(
                enabled: reservation.canSubmit,
              ),
              onPressed: reservation.canSubmit
                  ? () {
                GoRouter.of(context).go('/payment');
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




/*
Row(
                  children: const [
                    Expanded(
                      child: _DateBox(
                        title: '체크인',
                        value: '2025.12.30 (화)\n15:00',
                      ),
                    ),
                    SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _DateBox(
                        title: '체크아웃',
                        value: '2026.12.31 (수)\n11:00',
                      ),
                    ),
                  ],
                ),

// =====================
// 날짜 박스
// =====================
class _DateBox extends StatelessWidget {
  final String title;
  final String value;

  const _DateBox({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 108,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4FF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF8B8B8B),
            ),
          ),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
*/

