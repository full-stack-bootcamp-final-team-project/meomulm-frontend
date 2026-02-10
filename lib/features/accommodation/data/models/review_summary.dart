class ReviewSummaryModel {
  final double averageRating;
  final int totalCount;
  final String latestContent;

  ReviewSummaryModel({
    required this.averageRating,
    required this.totalCount,
    required this.latestContent,
  });

  factory ReviewSummaryModel.fromJson(Map<String, dynamic> json) {
    return ReviewSummaryModel(
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      totalCount: json['totalCount'] as int? ?? 0,
      latestContent: json['latestContent'] as String? ?? '아직 작성된 리뷰가 없습니다.',
    );
  }
}