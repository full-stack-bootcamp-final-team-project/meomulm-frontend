import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';

class ReservationApiService {

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiPaths.reservationUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  /// 예약 생성 API
  ///
  /// 백엔드 응답 body에 reservationId가 포함되어 있으면 파싱하여 반환.
  /// 백엔드에서 아직 reservationId를 응답본문에 넣지 않은 경우,
  /// 아래 주석 부분을 참고하여 백엔드 수정이 필요함.
  ///
  /// 반환값: reservationId (int)
  static Future<int> postReservation(
      String token,
      int productId,
      String bookerName,
      String bookerEmail,
      String bookerPhone,
      DateTime checkInDate,
      DateTime checkOutDate,
      int guestCount,
      int totalPrice,
      ) async {
    final res = await _dio.post(
      '',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
      data: {
        'productId': productId,
        'bookerName': bookerName,
        'bookerEmail': bookerEmail,
        'bookerPhone': bookerPhone,
        'checkInDate': checkInDate.toIso8601String(),
        'checkOutDate': checkOutDate.toIso8601String(),
        'guestCount': guestCount,
        'totalPrice': totalPrice,
      },
    );

    if (res.statusCode == 200) {
      // ── 백엔드가 { "reservationId": 123 } 형태로 응답하는 경우 ──
      // 백엔드 ReservationController.postReservation()의 반환값을
      // ResponseEntity.ok().body(Map.of("reservationId", reservation.getReservationId()))
      // 로 변경하면 아래 파싱이 곧바로 작동한다.
      final int reservationId = res.data['reservationId'] as int;
      debugPrint('[ReservationApiService] 예약 완료 | reservationId=$reservationId');
      return reservationId;
    } else {
      throw Exception('예약 실패: 상태코드 ${res.statusCode}');
    }
  }
}