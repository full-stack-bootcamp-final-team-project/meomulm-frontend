/// 백엔드에서 받은 PaymentIntent 정보를 앱 내부에서 관리하는 모델
///
/// [clientSecret]    – Stripe client_secret (SDK confirmPayment에 사용)
/// [paymentIntentId] – PaymentIntent ID (pi_xxxxx) — confirm 후 백엔드 확인에 사용
/// [amount]          – 결제 금액
/// [reservationId]   – 대응 예약 ID
class PaymentIntentDto {
  final String clientSecret;
  final String paymentIntentId;
  final int amount;
  final int reservationId;

  const PaymentIntentDto({
    required this.clientSecret,
    required this.paymentIntentId,
    required this.amount,
    required this.reservationId,
  });

  /// client_secret 에서 paymentIntentId 파싱
  /// 형식: "pi_xxxxx_secret_yyyyy"  →  "pi_xxxxx"
  factory PaymentIntentDto.fromClientSecret({
    required String clientSecret,
    required int amount,
    required int reservationId,
  }) {
    final paymentIntentId = clientSecret.split('_secret_').first;
    return PaymentIntentDto(
      clientSecret: clientSecret,
      paymentIntentId: paymentIntentId,
      amount: amount,
      reservationId: reservationId,
    );
  }
}