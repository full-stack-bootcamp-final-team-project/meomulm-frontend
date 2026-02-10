class AccommodationImageModel {
  final int accommodationImageId;
  final int accommodationId;
  final String accommodationImageUrl;

  const AccommodationImageModel({
    required this.accommodationImageId,
    required this.accommodationId,
    required this.accommodationImageUrl
  });

  factory AccommodationImageModel.fromJson(Map<String, dynamic> json) {
    return AccommodationImageModel(
        accommodationImageId: json['accommodationImageId'],
        accommodationId: json['accommodationId'],
        accommodationImageUrl: json['accommodationImageUrl'],
    );
  }
}