class ReservationUpdateRequestModel {
  final int reservationId;
  final String bookerName;
  final String bookerEmail;
  final String bookerPhone;

  const ReservationUpdateRequestModel({
    required this.reservationId,
    required this.bookerName,
    required this.bookerEmail,
    required this.bookerPhone,
  });

  Map<String, dynamic> toJson() {
    return {
      'reservationId': reservationId,
      'bookerName': bookerName,
      'bookerEmail': bookerEmail,
      'bookerPhone': bookerPhone,
    };
  }
}