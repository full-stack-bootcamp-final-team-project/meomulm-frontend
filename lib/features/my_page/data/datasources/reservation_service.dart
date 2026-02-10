import 'package:dio/dio.dart';
import 'package:meomulm_frontend/core/constants/paths/api_paths.dart';
import 'package:meomulm_frontend/features/my_page/data/models/accommodation_image_model.dart';
import 'package:meomulm_frontend/features/my_page/data/models/reservation_response_model.dart';
import 'package:meomulm_frontend/features/my_page/data/models/reservation_update_request_model.dart';

class ReservationService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiPaths.baseUrl,
      connectTimeout: const Duration(seconds: 10),  // 10초 타임아웃
      receiveTimeout: const Duration(seconds: 30),  // 30초 타임아웃
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  /*
  예약 내역 조회 : /api/users/reservation
   */
  Future<List<ReservationResponseModel>> loadReservations(String token) async {
    try {
      final response = await _dio.get(
        '/users/reservation',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      final List<dynamic> data = response.data;
      return data.map((json) => ReservationResponseModel.fromJson(json)).toList();
    } catch (e) {
      print('예약내역 조회 실패: $e');
      throw Exception('예약내역을 불러올 수 없습니다.');
    }
  }

  /*
  호텔 이미지 조회 : /api/accommodation/{accommodationId}
   */
  Future<AccommodationImageModel> loadAccommodationImage(String token, int accommodationId) async {
    try {
      final response = await _dio.get(
        '/accommodation/$accommodationId',
      );

      if (response.data is! Map) {
        throw Exception('Unexpected response type: ${response.data.runtimeType}');
      }

      // final Map<String, dynamic> json = response.data;
      final json = Map<String, dynamic>.from(response.data as Map);
      return AccommodationImageModel.fromJson(json);
    } catch (e) {
      print('숙소 이미지 조회 실패: $e');
      throw Exception('숙소 이미지를 불러올 수 없습니다.');
    }
  }

  /*
  에약 취소 : /api/reservation (delete)
   */
  Future<bool> putReservation(String token, int reservationId) async {
    try {
      final response = await _dio.put(
        '/reservation',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
        data: {'reservationId': reservationId},
      );
      return true;
    } catch (e) {
      print('예약 취소 실패: $e');
      throw Exception('예약 취소에 실패했습니다.');
    }
  }


  /*
  예약 수정 : /api/reservation (patch)
   */
  Future<bool> updateReservation(String token, ReservationUpdateRequestModel reservation) async {
    try {
      final response = await _dio.patch(
        '/reservation',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
        data: reservation.toJson(),
      );
      return true;
    } catch (e) {
      print('예약 수정 실패: $e');
      throw Exception('예약 수정에 실패했습니다.');
    }
  }


  /*
  에약 취소 : /api/reservation (delete)
   */
  Future<bool> deleteReservation(String token, int reservationId) async {
    try {
      final response = await _dio.delete(
        '/reservation',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
        data: {'reservationId': reservationId},
      );
      return true;
    } catch (e) {
      print('예약 취소 실패: $e');
      throw Exception('예약 취소에 실패했습니다.');
    }
  }
}
