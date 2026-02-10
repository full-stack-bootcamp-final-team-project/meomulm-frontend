/// ===============================
/// 예약 - 리뷰작성 - 위젯에서 공유되는 데이터 DTO
/// ===============================
// enum ReservationStatus {
//   PAID,
//   USED,
//   CANCELED,
// }
class ReservationShareModel {
  final int reservationId;
  final int accommodationId;
  final String accommodationName;
  final String? accommodationImageUrl;
  final String productName;
  final String productCheckInTime;
  final String productCheckOutTime;
  final String checkInDate;
  final String checkOutDate;
  final String status;

  const ReservationShareModel({
    required this.reservationId,
    required this.accommodationId,
    required this.accommodationName,
    this.accommodationImageUrl,
    required this.productName,
    required this.productCheckInTime,
    required this.productCheckOutTime,
    required this.checkInDate,
    required this.checkOutDate,
    required this.status,
  });

  DateTime _parseDate(String date) {
    final parts = date.split("-");
    final year = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final day = int.parse(parts[2]);
    return DateTime(year, month, day);
  }

  String weekdayKo(DateTime date) {
    const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    return weekdays[date.weekday - 1];
  }

  DateTime get parsedCheckInDate => _parseDate(checkInDate);
  DateTime get parsedCheckOutDate => _parseDate(checkOutDate);
  DateTime get chekInWeekday => _parseDate(checkInDate);
  DateTime get chekOutWeekday => _parseDate(checkOutDate);

  // 몇 박인지 계산
  int get nights => parsedCheckOutDate.difference(parsedCheckInDate).inDays;

  String get subtitle => '$productName · ${nights}박';
  String get checkInText =>
      '${parsedCheckInDate.month.toString().padLeft(2, '0')}.${parsedCheckInDate.day.toString().padLeft(2, "0")} (${weekdayKo(parsedCheckInDate)})';
  String get checkOutText =>
      '${parsedCheckOutDate.month.toString().padLeft(2, '0')}.${parsedCheckOutDate.day.toString().padLeft(2, "0")} (${weekdayKo(parsedCheckOutDate)})';

  String get productCheckInTimeOnly {
    final match = RegExp(r'\b\d{2}:\d{2}\b').firstMatch(productCheckInTime);
    return match?.group(0) ?? '';
  }

  String get productCheckOutTimeOnly {
    final match = RegExp(r'\b\d{2}:\d{2}\b').firstMatch(productCheckOutTime);
    return match?.group(0) ?? '';
  }
}