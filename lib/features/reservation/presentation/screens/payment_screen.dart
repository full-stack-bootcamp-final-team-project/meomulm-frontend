import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/core/widgets/appbar/app_bar_widget.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/providers/accommodation_provider.dart';
import 'package:meomulm_frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:meomulm_frontend/features/my_page/data/datasources/reservation_service.dart';
import 'package:meomulm_frontend/features/reservation/data/datasources/stripe_service.dart';
import 'package:meomulm_frontend/features/reservation/data/models/payment_intent_dto.dart';
import 'package:meomulm_frontend/features/reservation/presentation/providers/reservation_provider.dart';
import 'package:provider/provider.dart';

/// Stripe 테스트 카드 결제 화면
///
/// 흐름:
///   1. 화면 진입 시 백엔드에 금액을 보내 client_secret 받기
///   2. CardFormField 위짓으로 카드 정보 입력
///   3. "결제하기" 버튼 → confirmPayment(client_secret) → Stripe 테스트 서버 결제
///   4. 결제 성공 → 백엔드 /stripe/confirm 호출 → DB 저장
///   5. 결제 완료 화면으로 이동
class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  // ── 상태 변수 ──
  bool _isLoading = true;        // 초기 client_secret 로딩
  bool _isCardFilled = false;    // 카드 폼 입력 완료 여부
  bool _isProcessing = false;    // 결제 진행 중
  String? _errorMessage;         // 에러 메시지

  PaymentIntentDto? _paymentIntent; // client_secret 등 정보 보관

  // ── CardFormEditController ──
  // flutter_stripe 의 카드 폼 상태를 관리하는 컨트롤러.
  // controller.details.complete 가 true 이면 카드 번호/만료일/CVC 모두 입력된 상태.
  final CardFormEditController _cardFormController = CardFormEditController();

  @override
  void initState() {
    super.initState();
    _cardFormController.addListener(_onCardFormChanged);
    _fetchPaymentIntent();
  }

  @override
  void dispose() {
    _cardFormController.removeListener(_onCardFormChanged);
    _cardFormController.dispose();
    super.dispose();
  }

  /// CardFormEditController 리스너 콜백
  /// 폼 내용이 바뀌는 마다마다 complete 여부를 갱신
  void _onCardFormChanged() {
    final complete = _cardFormController.details.complete;
    if (_isCardFilled != complete) {
      setState(() {
        _isCardFilled = complete;
      });
    }
  }

  // ─────────────────────────────────────────────
  // Step 1: 백엔드에서 client_secret 가져오기
  // ─────────────────────────────────────────────
  Future<void> _fetchPaymentIntent() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final token = context.read<AuthProvider>().token;
      if (token == null) throw Exception('로그인이 필요합니다.');

      final reservationProvider = context.read<ReservationProvider>();
      final reservationId = reservationProvider.reservationId;
      final reservationInfo = reservationProvider.reservation;

      if (reservationId == null || reservationInfo == null) {
        throw Exception('예약 정보가 없습니다. 예약 화면에서 다시 시작해주세요.');
      }

      final int amount = reservationInfo.totalPrice;

      // 백엔드 API 호출 → client_secret 반환
      final String clientSecret = await StripeService.createPaymentIntent(
        token: token,
        amount: amount,
        currency: 'krw',
        reservationId: reservationId,
      );

      if (!mounted) return;
      setState(() {
        _paymentIntent = PaymentIntentDto.fromClientSecret(
          clientSecret: clientSecret,
          amount: amount,
          reservationId: reservationId,
        );
        _isLoading = false;
      });

      debugPrint('[PaymentScreen] client_secret 수신 완료 | pi=${_paymentIntent?.paymentIntentId}');

    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
      debugPrint('[PaymentScreen] _fetchPaymentIntent 실패: $e');
    }
  }

  // ─────────────────────────────────────────────
  // Step 3 & 4: 결제 실행
  // ─────────────────────────────────────────────
  Future<void> _processPayment() async {
    if (_paymentIntent == null) return;

    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    try {
      // ── Step 3: Stripe SDK confirmPayment ──
      //
      // 실제 flutter_stripe API 시그니처:
      //   Future<PaymentIntent> confirmPayment(
      //     String paymentIntentClientSecret,   ← 첫 번째 위치 파라미터
      //     PaymentMethodParams? data,          ← 두 번째 위치 파라미터 (선택)
      //   )
      //
      // PaymentMethodParams.card() 안에 paymentMethodData를 넘기면
      // CardFormField 에서 입력받은 카드 정보와 매칭된다.
      await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: _paymentIntent!.clientSecret,
        data: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(),
        ),
      );

      debugPrint('[PaymentScreen] Stripe confirmPayment 완료');

      // ── Step 4: 백엔드에 결제 확인 요청 ──
      if (!mounted) return;
      final token = context.read<AuthProvider>().token!;

      await StripeService.confirmPayment(
        token: token,
        paymentIntentId: _paymentIntent!.paymentIntentId,
        reservationId: _paymentIntent!.reservationId,
      );

      debugPrint('[PaymentScreen] 백엔드 confirm 완료 → 성공 화면으로');

      // ── Step 5: 결제 완료 화면으로 이동 ──
      if (!mounted) return;

      // 예약 정보 초기화 (다음 예약을 위해)
      context.read<ReservationProvider>().clearReservation();

      GoRouter.of(context).push('/payment-success');

    } on StripeException catch (e) {
      if (!mounted) return;
      setState(() {
        _isProcessing = false;
        _errorMessage = 'Stripe 결제 실패: ${e.error.localizedMessage ?? e.error.message}';
      });
      debugPrint('[PaymentScreen] StripeException: ${e.error.message}');

    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isProcessing = false;
        _errorMessage = '결제 처리 실패: $e';
      });
      debugPrint('[PaymentScreen] 결제 실패: $e');
    }
  }



  Future<void> _cancelReservation() async {
    final reservationProvider = context.read<ReservationProvider>();

    // 예약이 없으면 바로 종료
    final reservationId = reservationProvider.reservationId;
    if (reservationId == null) {
      debugPrint('취소할 예약이 없습니다.');
      return;
    }

    setState(() {
      _isLoading = true; // 로딩 상태 시작
    });

    try {
      // 토큰 가져오기
      final token = context.read<AuthProvider>().token;
      if (token == null) {
        return;
      }

      final reservationService = ReservationService();

      // ── 예약 취소 API 호출 ──
      final bool cancelSuccess = await reservationService.deleteReservation(
        token,
        reservationId,
      );

      if (!mounted) return;

      if (cancelSuccess) {
        // 취소 성공 시 Provider 초기화
        // reservationProvider.clearReservation();

        // 취소 후 화면 닫기
        Navigator.of(context).maybePop();
        debugPrint('예약이 성공적으로 취소되었습니다.');
      } else {
        debugPrint('예약 취소 실패: API 응답 실패');
      }

    } catch (e) {
      debugPrint('예약 취소 실패: $e');
    } finally {
      // mounted 체크 후 로딩 종료
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }


  // ─────────────────────────────────────────────
  // build
  // ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final reservationProvider = context.watch<ReservationProvider>();
    final accommodation = context.watch<AccommodationProvider>();
    final reservationInfo = reservationProvider.reservation;
    final accommodationName = accommodation.selectedAccommodationName;

    final String displayPrice = reservationInfo?.totalCommaPrice ?? '정보 없음';

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBarWidget(
        title: TitleLabels.payment,
        onBack: _cancelReservation,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.lg),

                // ── 숙소 정보 ──
                Text(
                  accommodationName ?? '숙소 정보 없음',
                  style: AppTextStyles.bodyXl,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  reservationInfo?.productName ?? '객실 정보 없음',
                  style: AppTextStyles.bodyLg,
                ),

                const SizedBox(height: AppSpacing.md),
                const Divider(thickness: 1, color: AppColors.gray3),
                const SizedBox(height: AppSpacing.md),

                // ── 결제 정보 ──
                const Text(
                  '결제 정보',
                  style: AppTextStyles.bodyXl,
                ),
                const SizedBox(height: AppSpacing.sm),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('총 객실 가격', style: AppTextStyles.bodyLg),
                    Text(displayPrice, style: AppTextStyles.bodyLg),
                  ],
                ),

                const SizedBox(height: AppSpacing.md),
                const Divider(thickness: 1, color: AppColors.gray3),
                const SizedBox(height: AppSpacing.xl),

                // ── 카드 정보 라벨 ──
                const Text(
                  '카드 정보',
                  style: AppTextStyles.cardTitle,
                ),
                const SizedBox(height: AppSpacing.md),

                // ── CardFormField 또는 로딩/에러 ──
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (_errorMessage != null)
                  _buildErrorWidget()
                else
                  _buildCardFormField(),

                const SizedBox(height: AppSpacing.xl),

                // ── Stripe 테스트 카드 번호 참고 ──
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.gray6,
                    borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '테스트 카드 번호',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.gray2,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '성공: 4242 4242 4242 4242',
                        style: TextStyle(fontSize: 13, color: AppColors.gray1),
                      ),
                      Text(
                        '실패: 4000 0000 0000 0002',
                        style: TextStyle(fontSize: 13, color: AppColors.gray1),
                      ),
                      Text(
                        '만료일: 임의 미래 날짜 | CVC: 임의 3자리',
                        style: TextStyle(fontSize: 12, color: AppColors.gray2),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.xxxl),

                // ── 결제 버튼 ──
                GestureDetector(
                  onTap: (_isCardFilled && !_isProcessing && _paymentIntent != null)
                      ? _processPayment
                      : null,
                  child: Container(
                    width: double.infinity,
                    height: AppSpacing.xxxl,
                    decoration: BoxDecoration(
                      color: (_isCardFilled && !_isProcessing && _paymentIntent != null)
                          ? AppColors.onPressed
                          : AppColors.disabled,
                      borderRadius: BorderRadius.circular(AppBorderRadius.md),
                    ),
                    alignment: Alignment.center,
                    child: _isProcessing
                        ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                      ),
                    )
                        : Text(
                      ButtonLabels.payWithPrice(_paymentIntent?.amount ?? 0),
                      style: AppTextStyles.buttonLg,
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // CardFormField 위짓
  // ─────────────────────────────────────────────
  /// flutter_stripe 의 실제 카드 폼 위짓은 CardFormField.
  /// controller 파라미터에 CardFormEditController 를 넘기면
  /// 내부적으로 카드 번호/만료일/CVC 입력 폼을 렌더링하고,
  /// controller.details.complete 로 입력 완료 여부를 알 수 있다.
  Widget _buildCardFormField() {
    // ✅ 모바일(Android/iOS)에서만 Stripe 카드 폼 렌더링
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      return CardFormField(
        controller: _cardFormController,
        style: CardFormStyle(
          backgroundColor: AppColors.gray6,
          textColor: AppColors.black,
          placeholderColor: AppColors.gray2,
        ),
      );
    }

    // ✅ 그 외 플랫폼에서는 안내 UI
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.gray6,
        borderRadius: BorderRadius.circular(AppBorderRadius.sm),
      ),
      child: const Text(
        '결제는 모바일 앱(Android / iOS)에서만 가능합니다.',
        style: TextStyle(color: AppColors.gray2),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // 에러 표시
  // ─────────────────────────────────────────────
  Widget _buildErrorWidget() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(AppBorderRadius.sm),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              _errorMessage!,
              style: const TextStyle(color: AppColors.error, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}