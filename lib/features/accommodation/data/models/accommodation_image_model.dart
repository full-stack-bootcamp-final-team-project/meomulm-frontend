
class AccommodationImage {
  final int accommodationImageId;
  final int? accommodationId;
  final String accommodationImageUrl;

  AccommodationImage({
    required this.accommodationImageId,
    this.accommodationId,
    required this.accommodationImageUrl

  });

  factory AccommodationImage.fromJson(Map<String, dynamic> json) {
    try {
      return AccommodationImage(
        accommodationImageId: json['accommodationImageId'] ?? 0,
        accommodationId: json['accommodationId'],
        accommodationImageUrl: json['accommodationImageUrl'] ?? '',
      );
    } catch (e) {
      throw Exception('Result.fromJson 파싱 실패: $e\nJSON: $json');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'accommodationImageId': accommodationImageId,
      'accommodationId': accommodationId,
      'accommodationImageUrl': accommodationImageUrl
    };
  }

}


