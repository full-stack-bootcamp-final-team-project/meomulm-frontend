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
}