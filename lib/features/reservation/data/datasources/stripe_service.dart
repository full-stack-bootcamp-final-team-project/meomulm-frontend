import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';

/// Stripe 관련 백엔드 API 호출 서비스
///
/// ① createPaymentIntent  – 백엔드에 금액을 보내 client_secret 받기
/// ② confirmPayment       – SDK 결제 완료 후 백엔드에 확인 요청
class StripeService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiPaths.paymentUrl, // http://localhost:8080/api/payment
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  /// ─── ① PaymentIntent 생성 ───
  /// 백엔드 → Stripe 테스트 서버 → client_secret 반환
  ///
  /// [token]         – JWT 토큰
  /// [amount]        – 결제 금액 (원 단위 정수)
  /// [currency]      – 통폐화 코드 (예: "krw")
  /// [reservationId] – 해당 예약 ID
  ///
  /// 반환값: client_secret (String)
  static Future<String> createPaymentIntent({
    required String token,
    required int amount,
    required String currency,
    required int reservationId,
  }) async {
    try {
      final res = await _dio.post(
        '/stripe/create-payment-intent',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
        data: {
          'amount': amount,
          'currency': currency,
          'reservationId': reservationId,
        },
      );

      if (res.statusCode == 200 && res.data != null) {
        return res.data['clientSecret'] as String;
      }
      throw Exception('createPaymentIntent 응답 형식 오류');
    } on DioException catch (e) {
      debugPrint('[StripeService] createPaymentIntent 실패: ${e.response?.data ?? e.message}');
      throw Exception('PaymentIntent 생성 실패: ${e.response?.data?['message'] ?? e.message}');
    }
  }

  /// ─── ② 결제 확인 (Flutter SDK confirmPayment 완료 후) ───
  /// 백엔드가 Stripe 상태를 재조회하여 DB 저장
  ///
  /// [token]           – JWT 토큰
  /// [paymentIntentId] – Stripe PaymentIntent ID (pi_xxxxx)
  /// [reservationId]   – 해당 예약 ID
  static Future<void> confirmPayment({
    required String token,
    required String paymentIntentId,
    required int reservationId,
  }) async {
    try {
      final res = await _dio.post(
        '/stripe/confirm',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
        data: {
          'paymentIntentId': paymentIntentId,
          'reservationId': reservationId,
        },
      );

      if (res.statusCode != 200) {
        throw Exception('confirmPayment 비200 응답: ${res.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint('[StripeService] confirmPayment 실패: ${e.response?.data ?? e.message}');
      throw Exception('결제 확인 실패: ${e.response?.data?['message'] ?? e.message}');
    }
  }
}