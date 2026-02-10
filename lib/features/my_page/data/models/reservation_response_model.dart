/// ===============================
/// 예약 조회 응답 모델
/// ===============================
class ReservationResponseModel {
  final int accommodationId;
  final String accommodationName;
  final int productId;
  final String productName;
  final String productCheckInTime;
  final String productCheckOutTime;
  final int reservationId;
  final int userId;
  final String checkInDate;
  final String checkOutDate;
  final  String status;

  const ReservationResponseModel({
    required this.accommodationId,
    required this.accommodationName,
    required this.productId,
    required this.productName,
    required this.productCheckInTime,
    required this.productCheckOutTime,
    required this.reservationId,
    required this.userId,
    required this.checkInDate,
    required this.checkOutDate,
    required this.status,
  });

  factory ReservationResponseModel.fromJson(Map<String, dynamic> json) {
    return ReservationResponseModel(
        accommodationId: json['accommodationId'],
        accommodationName: json['accommodationName'],
        productId: json['productId'],
        productName: json['productName'],
        productCheckInTime: json['productCheckInTime'],
        productCheckOutTime: json['productCheckOutTime'],
        reservationId: json['reservationId'],
        userId: json['userId'],
        checkInDate: json['checkInDate'],
        checkOutDate: json['checkOutDate'],
        status: json['status']
    );
  }
}