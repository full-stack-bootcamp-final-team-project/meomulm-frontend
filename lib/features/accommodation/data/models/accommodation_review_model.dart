// lib/features/accommodation/data/models/accommodation_review_model.dart

class AccommodationReviewModel {
  final int reviewId;
  final int userId;
  final int accommodationId;
  final int rating;
  final String reviewContent;
  final String createdAt;
  final String? userName;           // JOIN으로 가져오는 값 (null 방어)
  final String? userProfileImage;   // JOIN으로 가져오는 값 (null 방어)

  AccommodationReviewModel({
    required this.reviewId,
    required this.userId,
    required this.accommodationId,
    required this.rating,
    required this.reviewContent,
    required this.createdAt,
    this.userName,
    this.userProfileImage,
  });

  // JSON -> Object 변환 (백엔드 필드명과 1:1 매칭)
  factory AccommodationReviewModel.fromJson(Map<String, dynamic> json) {
    return AccommodationReviewModel(
      reviewId: json['reviewId'] ?? 0,
      userId: json['userId'] ?? 0,
      accommodationId: json['accommodationId'] ?? 0,
      rating: json['rating'] ?? 0,
      reviewContent: json['reviewContent'] ?? '',
      createdAt: json['createdAt'] ?? '',
      userName: json['userName'],
      userProfileImage: json['userProfileImage'],
    );
  }

  // Object -> JSON 변환 (필요 시 사용)
  Map<String, dynamic> toJson() {
    return {
      'reviewId': reviewId,
      'userId': userId,
      'accommodationId': accommodationId,
      'rating': rating,
      'reviewContent': reviewContent,
      'createdAt': createdAt,
      'userName': userName,
      'userProfileImage': userProfileImage,
    };
  }
}