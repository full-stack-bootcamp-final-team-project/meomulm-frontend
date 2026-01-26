// lib/features/reservation/data/models/reservation_info.dart
class ReservationInfo {
  final int roomId;
  final String accommodationName;
  final String roomType;
  final String baseCapacity;
  final String price;

  ReservationInfo({
    required this.roomId,
    required this.accommodationName,
    required this.roomType,
    required this.baseCapacity,
    required this.price,
  });
}

