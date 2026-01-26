// lib/features/reservation/presentation/providers/reservation_form_provider.dart
import 'package:flutter/material.dart';
import 'package:meomulm_frontend/features/reservation/data/models/reservation_info.dart';

class ReservationProvider extends ChangeNotifier {
  ReservationInfo? _reservation;

  ReservationInfo? get reservation => _reservation;

  bool get hasReservation => _reservation != null;

  void setReservation(ReservationInfo reservation) {
    _reservation = reservation;
    notifyListeners();
  }

  void clearReservation() {
    _reservation = null;
    notifyListeners();
  }
}

