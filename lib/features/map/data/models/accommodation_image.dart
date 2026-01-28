// accommodation_image.dart
class AccommodationImage {
  final int imageId;
  final String imageUrl;
  final int imageOrder;

  AccommodationImage({
    required this.imageId,
    required this.imageUrl,
    required this.imageOrder,
  });

  factory AccommodationImage.fromJson(Map<String, dynamic> json) {
    return AccommodationImage(
      imageId: json['imageId'] ?? 0,
      imageUrl: json['imageUrl'] ?? '',
      imageOrder: json['imageOrder'] ?? 0,
    );
  }
}