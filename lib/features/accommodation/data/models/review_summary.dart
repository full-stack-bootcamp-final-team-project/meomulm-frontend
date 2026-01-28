class ReviewSummary {
  final double averageRating;
  final int totalCount;
  final String latestContent;

  ReviewSummary({
    required this.averageRating,
    required this.totalCount,
    required this.latestContent,
  });

  factory ReviewSummary.fromJson(Map<String, dynamic> json) {
    return ReviewSummary(
      // PostgreSQL에서 numeric/double로 올 수 있으므로 num 처리 후 toDouble
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      totalCount: json['totalCount'] as int? ?? 0,
      latestContent: json['latestContent'] as String? ?? '아직 작성된 리뷰가 없습니다.',
    );
  }
}