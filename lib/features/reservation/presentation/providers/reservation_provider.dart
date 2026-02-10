import 'package:flutter/material.dart';
import 'package:meomulm_frontend/features/reservation/data/models/reservation_info.dart';

/// 예약 & 결제 흐름 전반에서 공유되는 상태 Provider
///
/// - reservation      : 객실 정보 (숙소명, 금액, 날짜 등)
/// - reservationId    : 백엔드에서 생성된 예약 ID (결제 API에 전달)
class ReservationProvider extends ChangeNotifier {
  ReservationInfo? _reservation;
  int? _reservationId;

  // ── 예약자 정보 추가 ──
  String? _bookerName;
  String? _bookerEmail;
  String? _bookerPhone;

  // ── reservation (객실 정보) ──
  ReservationInfo? get reservation => _reservation;
  bool get hasReservation => _reservation != null;

  void setReservation(ReservationInfo reservation) {
    _reservation = reservation;
    notifyListeners();
  }

  void clearReservation() {
    _reservation = null;
    _reservationId = null;

    _bookerName = null;
    _bookerEmail = null;
    _bookerPhone = null;
    notifyListeners();
  }

  // ── reservationId (백엔드 생성 예약 ID) ──
  int? get reservationId => _reservationId;

  void setReservationId(int id) {
    _reservationId = id;
    notifyListeners();
  }

  // ── 예약자 정보 getter/setter ──
  String? get bookerName => _bookerName;
  String? get bookerEmail => _bookerEmail;
  String? get bookerPhone => _bookerPhone;

  void setBookerInfo({required String name, required String email, required String phone}) {
    _bookerName = name;
    _bookerEmail = email;
    _bookerPhone = phone;
    notifyListeners();
  }

  // 예약자 정보만 초기화
  void clearBookerInfo() {
    _bookerName = null;
    _bookerEmail = null;
    _bookerPhone = null;
    notifyListeners();
  }
}