import 'package:dio/dio.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/features/reservation/data/models/reservation_model.dart';


class ReservationApiService {

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiPaths.reservationUrl,
      connectTimeout : const Duration(seconds: 5),
      receiveTimeout : const Duration(seconds: 3),
      headers:{
        'Content-Type' : 'application/json',
      },
    ),
  );

  static Future<void> postReservation(
      String token,
      int productId,
       String bookerName,
       String bookerEmail,
       String bookerPhone,
       DateTime checkInDate,
      DateTime checkOutDate,
       int guestCount,
       String status,
       int totalPrice
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
        'status': status,
        'totalPrice': totalPrice,
      },
    );

    if (res.statusCode == 200) {
      print(res.data);
    } else {
      // constants 에서 지정한 에러 타입으로 교체
      throw Exception('에러발생');
    }
  }

}



