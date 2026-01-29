// accommodation_image.dart
class AccommodationImage {
  final int imageId;
  final String imageUrl;

  AccommodationImage({required this.imageId, required this.imageUrl});

  factory AccommodationImage.fromJson(Map<String, dynamic> json) {
    return AccommodationImage(
      imageId: json['accommodationImageId'] ?? 0,        // ← 키 이름 수정
      imageUrl: json['accommodationImageUrl'] ?? '',     // ← 키 이름 수정
    );
  }
}
/*
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

 */