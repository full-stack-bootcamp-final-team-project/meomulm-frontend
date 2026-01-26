/// ===============================
/// 데이터 모델
/// TODO: 백엔드 형식에 맞춰서 수정
/// ===============================
class ReviewModel {
  final String hotelName;
  final String dateText;
  final double rating;
  final String content;

  const ReviewModel({
    required this.hotelName,
    required this.dateText,
    required this.rating,
    required this.content,
  });
}