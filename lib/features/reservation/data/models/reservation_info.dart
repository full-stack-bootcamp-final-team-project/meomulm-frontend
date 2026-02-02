// lib/features/reservation/data/models/reservation_info.dart
class ReservationInfo {
  final int roomId;
  final String productName;
  final String price;
  final String checkInfo;
  final String peopleInfo;

  ReservationInfo({
    required this.roomId,
    required this.productName,
    required this.price,
    required this.checkInfo,
    required this.peopleInfo
  });
}


