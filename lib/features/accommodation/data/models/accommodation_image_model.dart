
class AccommodationImageModel {
  final int accommodationImageId;
  final int? accommodationId;
  final String accommodationImageUrl;

  AccommodationImageModel({
    required this.accommodationImageId,
    this.accommodationId,
    required this.accommodationImageUrl

  });

  factory AccommodationImageModel.fromJson(Map<String, dynamic> json) {
    try {
      return AccommodationImageModel(
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

