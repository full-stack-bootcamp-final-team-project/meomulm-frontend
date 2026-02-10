class Reservation {
  final int reservationId;
  final int userId;
  final int productId;
  final String bookerName;
  final String bookerEmail;
  final String bookerPhone;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int guestCount;
  final String status;
  final int totalPrice;
  final String createdAt;
  final String updatedAt;

  Reservation({
    required this.reservationId,
    required this.userId,
    required this.productId,
    required this.bookerName,
    required this.bookerEmail,
    required this.bookerPhone,
    required this.checkInDate,
    required this.checkOutDate,
    required this.guestCount,
    required this.status,
    required this.totalPrice,
    required this.createdAt,
    required this.updatedAt,
  });

  // JSON -> Reservation 객체
  factory Reservation.fromJson(Map<String, dynamic> json) {
    try {
      return Reservation(
        reservationId: json['reservationId'] as int,
        userId: json['userId'] as int,
        productId: json['productId'] as int,
        bookerName: json['bookerName'] as String,
        bookerEmail: json['bookerEmail'] as String,
        bookerPhone: json['bookerPhone'] as String,
        checkInDate: json['checkInDate'] as DateTime,
        checkOutDate: json['checkOutDate'] as DateTime,
        guestCount: json['guestCount'] as int,
        status: json['status'] as String,
        totalPrice: json['totalPrice'] as int,
        createdAt: json['createdAt'] as String,
        updatedAt: json['updatedAt'] as String,
      );
    } catch (e) {
      throw Exception('Reservation.fromJson 파싱 실패: $e\nJSON: $json');
    }
  }

  // Reservation 객체 -> JSON
  Map<String, dynamic> toJson() {
    return {
      'reservationId': reservationId,
      'userId': userId,
      'productId': productId,
      'bookerName': bookerName,
      'bookerEmail': bookerEmail,
      'bookerPhone': bookerPhone,
      'checkInDate': checkInDate,
      'checkOutDate': checkOutDate,
      'guestCount': guestCount,
      'status': status,
      'totalPrice': totalPrice,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
