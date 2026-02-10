/// ===============================
/// 리뷰 조회 응답 모델
/// ===============================
class ReviewResponseModel {
  final int reviewId;
  final int userId;
  final int accommodationId;
  final int rating;
  final String reviewContent;
  final String createdAt;
  final String accommodationName;

  const ReviewResponseModel({
    required this.reviewId,
    required this.userId,
    required this.accommodationId,
    required this.rating,
    required this.reviewContent,
    required this.createdAt,
    required this.accommodationName
  });

  factory ReviewResponseModel.fromJson(Map<String, dynamic> json) {
    return ReviewResponseModel(
        reviewId: json['reviewId'],
        userId: json['userId'],
        accommodationId: json['accommodationId'],
        rating: json['rating'],
        reviewContent: json['reviewContent'],
        createdAt: json['createdAt'],
        accommodationName: json['accommodationName']
    );
  }

  DateTime _parseDate(String date) {
    final normalized = date.trim().replaceFirst(' ', 'T'); // " " -> "T"
    final dt = DateTime.tryParse(normalized);
    if (dt == null) {
      // 파싱 실패 시 크래시 대신 기본값(또는 현재시간) 처리
      return DateTime.fromMillisecondsSinceEpoch(0);
    }
    return dt;
  }

  DateTime get parsedReviewDate => _parseDate(createdAt);

  String get reviewDate =>
      '${parsedReviewDate.year}.${parsedReviewDate.month.toString().padLeft(2, '0')}.${parsedReviewDate.day.toString().padLeft(2, '0')}';

}