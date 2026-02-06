/// ===============================
/// 리뷰 작성 요청 모델
/// ===============================
class ReviewRequestModel {
  final int accommodationId;
  final int rating;
  final String reviewContent;

  const ReviewRequestModel({
    required this.accommodationId,
    required this.rating,
    required this.reviewContent,
  });

  Map<String, dynamic> toJson() => {
    'accommodationId': accommodationId,
    'rating': rating,
    'reviewContent': reviewContent,
  };
}