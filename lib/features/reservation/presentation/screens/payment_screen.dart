/*
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/constants/ui/labels_constants.dart';
import 'package:meomulm_frontend/core/theme/app_colors.dart';
import 'package:meomulm_frontend/core/theme/app_dimensions.dart';
import 'package:meomulm_frontend/core/theme/app_icons.dart';
import 'package:meomulm_frontend/core/theme/app_text_styles.dart';
import 'package:meomulm_frontend/core/widgets/appbar/app_bar_widget.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/providers/accommodation_provider.dart';
import 'package:meomulm_frontend/features/reservation/presentation/providers/reservation_provider.dart';
import 'package:provider/provider.dart';
import 'package:tosspayments_widget_sdk_flutter/payment_widget.dart';
import 'package:tosspayments_widget_sdk_flutter/widgets/payment_method.dart';
import 'package:tosspayments_widget_sdk_flutter/widgets/agreement.dart';
import 'package:tosspayments_widget_sdk_flutter/model/payment_info.dart';
import 'package:tosspayments_widget_sdk_flutter/model/payment_widget_options.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late PaymentWidget _paymentWidget;
  PaymentMethodWidgetControl? _paymentMethodWidgetControl;
  AgreementWidgetControl? _agreementWidgetControl;

  int _amount = 0; // 결제 금액 State 변수

  @override
  void initState() {
    super.initState();

    // Provider에서 예약 정보 가져오기
    final reservation = context.read<ReservationProvider>().reservation;
    final priceString = reservation?.price ?? '0';

    _amount = int.tryParse(priceString.replaceAll(',', '')) ?? 0;

    // PaymentWidget 초기화
    _paymentWidget = PaymentWidget(
      clientKey: "test_gck_docs_Ovk5rk1EwkEbP0W43n07xlzm",
      customerKey: "1Mn-hqv5LOFp_SS-7gRbS",
    );

    // 결제 수단 렌더링
    _paymentWidget.renderPaymentMethods(
      selector: 'methods',
      amount: Amount(value: _amount, currency: Currency.KRW, country: "KR"),
    ).then((control) {
      _paymentMethodWidgetControl = control;
    });

    // 약관 렌더링
    _paymentWidget.renderAgreement(selector: 'agreement').then((control) {
      _agreementWidgetControl = control;
    });
  }

  Future<void> _requestPayment() async {
    final paymentResult = await _paymentWidget.requestPayment(
      paymentInfo: PaymentInfo(
        orderId: DateTime.now().millisecondsSinceEpoch.toString(),
        orderName: '프리미어 패밀리 트윈',
      ),
    );

    if (paymentResult.success != null) {
      GoRouter.of(context).go('/success');
    } else if (paymentResult.fail != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('결제 실패')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Provider에서 예약 정보를 읽어서 화면 표시에도 사용
    final reservation = context.watch<ReservationProvider>().reservation;
    final product = context.watch<AccommodationProvider>();
    final accommodationName = product.selectedAccommodationName;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const AppBarWidget(
        title: TitleLabels.payment,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.lg),
                // 숙소 정보
                Text(
                  accommodationName ?? '숙소 정보 없음',
                  style: AppTextStyles.bodyXl
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  reservation?.productName ?? '객실 정보 없음',
                  style: AppTextStyles.bodyLg,
                ),

                const SizedBox(height: AppSpacing.md),
                const Divider(thickness: 1, color: AppColors.gray3),
                const SizedBox(height: AppSpacing.md),

                const Text(
                  '결제 정보',
                  style: AppTextStyles.bodyXl,
                ),

                const SizedBox(height: AppSpacing.sm),


                // 객실 가격
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '객실 가격',
                      style:  AppTextStyles.bodyLg,
                    ),
                    Text(
                      reservation?.price ?? '0원',
                      style:  AppTextStyles.bodyLg
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.md),
                const Divider(thickness: 1, color: AppColors.gray3),
                const SizedBox(height: AppSpacing.xl),

                // 결제 수단
                PaymentMethodWidget(
                  paymentWidget: _paymentWidget,
                  selector: 'methods',
                ),
                const SizedBox(height: AppSpacing.lg),

                // 약관
                AgreementWidget(
                  paymentWidget: _paymentWidget,
                  selector: 'agreement',
                ),

                const SizedBox(height: AppSpacing.xxxl),

                // 결제 버튼
                GestureDetector(
                  onTap: _requestPayment,
                  child: Container(
                    width: double.infinity,
                    height: AppSpacing.xxxl,
                    decoration: BoxDecoration(
                      color: AppColors.onPressed,
                      borderRadius: BorderRadius.circular(AppBorderRadius.md),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      ButtonLabels.payWithPrice(_amount),
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
}
*/


import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('빈 페이지'),
      ),
      body: const Center(
        child: Text(
          '아무 내용도 없는 페이지입니다',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
