import 'package:flutter/cupertino.dart';
import 'package:meomulm_frontend/features/my_page/data/datasources/reservation_service.dart';
import 'package:meomulm_frontend/features/my_page/data/models/accommodation_image_model.dart';
import 'package:meomulm_frontend/features/my_page/data/models/reservation_share_model.dart';

class MyReservationProvider with ChangeNotifier {
  final ReservationService _reservationService = ReservationService();

  List<ReservationShareModel> _reservations = [];
  List<ReservationShareModel> get reservations => _reservations;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage = "";
  String? get errorMessage => _errorMessage;

  // 상태별 예약내역 TODO: my_reservations_screen에서 삭제하기
  List<ReservationShareModel> get reservationsBefore =>
      reservations.where((r) => r.status == "PAID").toList();
  List<ReservationShareModel> get reservationsAfter  =>
      reservations.where((r) => r.status == "USED").toList();
  List<ReservationShareModel> get reservationsCanceled  =>
      reservations.where((r) => r.status == "CANCELED").toList();

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // 예약 불러오기
  Future<void> loadReservations(String token) async {
    _setLoading(true);
    try {
      final reservationResponse = await _reservationService.loadReservations(token);

      final shareModels = await Future.wait(
        reservationResponse.map((r) async {
          AccommodationImageModel? image;
          try {
            image = await _reservationService.loadAccommodationImage(token, r.accommodationId);
          } catch (_) {
            image = null;
          }

          return ReservationShareModel(
            reservationId: r.reservationId,
            accommodationId: r.accommodationId,
            accommodationName: r.accommodationName,
            accommodationImageUrl: image?.accommodationImageUrl,
            productName: r.productName,
            productCheckInTime: r.productCheckInTime,
            productCheckOutTime: r.productCheckOutTime,
            checkInDate: r.checkInDate,
            checkOutDate: r.checkOutDate,
            status: r.status,
          );
        })
      );

      _reservations = shareModels;
      notifyListeners();
    } catch (e) {
      _errorMessage = "예약 내역을 조회할 수 없습니다.";
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> cancelReservation(String token, int reservationId) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await _reservationService.putReservation(token, reservationId);

      _reservations = _reservations.map((r) {
        if(r.reservationId != reservationId) return r;

        return ReservationShareModel(
            reservationId: r.reservationId,
            accommodationId: r.accommodationId,
            accommodationName: r.accommodationName,
            productName: r.productName,
            productCheckInTime: r.productCheckInTime,
            productCheckOutTime: r.productCheckOutTime,
            checkInDate: r.checkInDate,
            checkOutDate: r.checkOutDate,
            status: "CANCELED",
        );
      }).toList();

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = "예약 취소에 실패했습니다.";
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }
}