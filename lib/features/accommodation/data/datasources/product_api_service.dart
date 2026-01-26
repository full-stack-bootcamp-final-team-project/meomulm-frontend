import 'package:dio/dio.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';

import '../models/product_response_model.dart';

class ProductApiService {

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiPaths.productUrl,
      connectTimeout : const Duration(seconds: 5),
      receiveTimeout : const Duration(seconds: 3),
      headers:{
        'Content-Type' : 'application/json',
      },
    ),
  );

  static Future<ProductResponse> getRoomsByAccommodationId(
      {
        required int accommodationId,   // 사용자가 고른 숙소
        required String checkInDate,     // 사용자가 고른 날짜
        required String checkOutDate,    // 사용자가 고른 날짜
        int guestCount = 2,              // 사용자가 안 고르면 기본값
      }
      ) async {
    final res = await _dio.get(
      '/$accommodationId',
      queryParameters: {
        'checkInDate': checkInDate,
        'checkOutDate': checkOutDate,
        'guestCount': guestCount,
      },
    );

    if (res.statusCode == 200) {
      return ProductResponse.fromJson(res.data);
    } else {
      // constants 에서 지정한 에러 타입으로 교체
      throw Exception('에러발생');
    }
  }

}