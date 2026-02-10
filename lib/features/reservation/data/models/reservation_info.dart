// lib/features/reservation/data/models/reservation_info.dart
class ReservationInfo {
  final int roomId;
  final String productName;
  final int price;
  final String commaPrice;
  final int totalPrice;
  final String totalCommaPrice;
  final int days;
  final String checkInfo;
  final String peopleInfo;


  ReservationInfo({
    required this.roomId,
    required this.productName,
    required this.price,
    required this.commaPrice,
    required this.totalPrice,
    required this.totalCommaPrice,
    required this.days,
    required this.checkInfo,
    required this.peopleInfo,
  });
}


