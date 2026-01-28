import 'accommodation_image.dart';

class Accommodation {
  final int accommodationId;
  final String accommodationName;
  final String accommodationAddress;
  final double accommodationLatitude;
  final double accommodationLongitude;
  final int minPrice;
  final List<AccommodationImage> accommodationImages;

  Accommodation({
    required this.accommodationId,
    required this.accommodationName,
    required this.accommodationAddress,
    required this.accommodationLatitude,
    required this.accommodationLongitude,
    required this.minPrice,
    required this.accommodationImages,
  });

  factory Accommodation.fromJson(Map<String, dynamic> json) {
    return Accommodation(
      accommodationId: json['accommodationId'] ?? 0,
      accommodationName: json['accommodationName'] ?? '',
      accommodationAddress: json['accommodationAddress'] ?? '',
      accommodationLatitude: (json['accommodationLatitude'] ?? 0.0).toDouble(),
      accommodationLongitude: (json['accommodationLongitude'] ?? 0.0).toDouble(),
      minPrice: json['minPrice'] ?? 0,
      accommodationImages: (json['accommodationImages'] as List<dynamic>?)
          ?.map((img) => AccommodationImage.fromJson(img))
          .toList() ??
          [],
    );
  }

  String get mainImageUrl {
    if (accommodationImages.isEmpty) return '';
    return accommodationImages.first.imageUrl;
  }
}