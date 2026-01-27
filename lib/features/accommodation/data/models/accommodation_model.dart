import 'package:meomulm_frontend/features/accommodation/data/models/accommodation_image_model.dart';
// import 'package:meomulm_frontend/features/accommodation/data/models/product_facility_model.dart';
// import 'package:meomulm_frontend/features/accommodation/data/models/product_image_model.dart';

class Accommodation {
  final int? accommodationId;
  final String? accommodationName;
  final String? accommodationAddress;
  final double? accommodationLatitude;
  final double? accommodationLongitude;
  final int? minPrice;
  final List<AccommodationImage>? accommodationImages;

  Accommodation({
    this.accommodationId,
    this.accommodationName,
    this.accommodationAddress,
    this.accommodationLatitude,
    this.accommodationLongitude,
    this.minPrice,
    this.accommodationImages,
  });

  factory Accommodation.fromJson(Map<String, dynamic> json) {
    try {
      return Accommodation(
        accommodationId: json['accommodationId'] as int?,
        accommodationName: json['accommodationName'] as String?,
        accommodationAddress: json['accommodationAddress'] as String?,
        accommodationLatitude: (json['accommodationLatitude'] as num?)?.toDouble(),
        accommodationLongitude: (json['accommodationLongitude'] as num?)?.toDouble(),
        minPrice: json['minPrice'] as int?,
        accommodationImages: json['accommodationImages'] != null
            ? (json['accommodationImages'] as List<dynamic>)
            .map((e) => AccommodationImage.fromJson(e as Map<String, dynamic>))
            .toList()
            : null,
      );
    } catch (e, stackTrace) {
      // 디버깅 편의를 위해 stackTrace도 함께 출력 가능
      print('Accommodation.fromJson 실패: $e');
      print(stackTrace);
      rethrow;  // 또는 throw 커스텀 예외로 변경 가능
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'accommodationId': accommodationId,
      'accommodationName': accommodationName,
      'accommodationAddress': accommodationAddress,
      'accommodationLatitude': accommodationLatitude,
      'accommodationLongitude': accommodationLongitude,
      'minPrice': minPrice,
      'accommodationImages': accommodationImages?.map((e) => e.toJson()).toList(),
    };
  }
}