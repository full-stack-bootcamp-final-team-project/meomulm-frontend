import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/core/widgets/appbar/app_bar_widget.dart';
import 'package:meomulm_frontend/core/widgets/buttons/bottom_action_button.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/providers/accommodation_provider.dart';
import 'package:meomulm_frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:meomulm_frontend/features/my_page/data/datasources/reservation_service.dart';
import 'package:meomulm_frontend/features/reservation/data/datasources/stripe_service.dart';
import 'package:meomulm_frontend/features/reservation/data/models/payment_intent_dto.dart';
import 'package:meomulm_frontend/features/reservation/presentation/providers/reservation_provider.dart';
import 'package:provider/provider.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isLoading = true;
  bool _isCardFilled = false;
  bool _isProcessing = false;
  String? _errorMessage;

  PaymentIntentDto? _paymentIntent;

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

  void _onCardFormChanged() {
    final complete = _cardFormController.details.complete;
    if (_isCardFilled != complete) {
      setState(() {
        _isCardFilled = complete;
      });
    }
  }

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

  Future<void> _processPayment() async {
    if (_paymentIntent == null) return;

    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    try {
      await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: _paymentIntent!.clientSecret,
        data: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(),
        ),
      );

      debugPrint('[PaymentScreen] Stripe confirmPayment 완료');

      if (!mounted) return;
      final token = context.read<AuthProvider>().token!;

      await StripeService.confirmPayment(
        token: token,
        paymentIntentId: _paymentIntent!.paymentIntentId,
        reservationId: _paymentIntent!.reservationId,
      );

      debugPrint('[PaymentScreen] 백엔드 confirm 완료 → 성공 화면으로');

      if (!mounted) return;
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
    final reservationId = reservationProvider.reservationId;
    if (reservationId == null) {
      debugPrint('취소할 예약이 없습니다.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final token = context.read<AuthProvider>().token;
      if (token == null) return;

      final reservationService = ReservationService();

      final bool cancelSuccess = await reservationService.deleteReservation(
        token,
        reservationId,
      );

      if (!mounted) return;

      if (cancelSuccess) {
        Navigator.of(context).maybePop();
        debugPrint('예약이 성공적으로 취소되었습니다.');
      } else {
        debugPrint('예약 취소 실패: API 응답 실패');
      }
    } catch (e) {
      debugPrint('예약 취소 실패: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final reservationProvider = context.read<ReservationProvider>();
    final accommodation = context.read<AccommodationProvider>();
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
        child: Stack(
          children: [
            // ── 스크롤 가능한 내용 ──
            Positioned.fill(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.lg,
                  120, // 버튼 높이 + 여유
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.lg),
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
                    const Text('결제 정보', style: AppTextStyles.bodyXl),
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
                    const Text('카드 정보', style: AppTextStyles.cardTitle),
                    const SizedBox(height: AppSpacing.md),
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (_errorMessage != null)
                      _buildErrorWidget()
                    else
                      _buildCardFormField(),
                    const SizedBox(height: AppSpacing.xl),
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
                  ],
                ),
              ),
            ),

            // ── 하단 버튼 고정 ──
            Positioned(
              left: AppSpacing.lg,
              right: AppSpacing.lg,
              bottom: AppSpacing.lg,
              child: BottomActionButton(
                label: ButtonLabels.payWithPrice(_paymentIntent?.amount ?? 0),
                onPressed: (_isCardFilled && !_isProcessing && _paymentIntent != null)
                    ? _processPayment
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardFormField() {
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
