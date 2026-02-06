import 'accommodation_image_model.dart';

class SearchAccommodationResponseModel {
  final int accommodationId;
  final String accommodationName;
  final String accommodationAddress;
  final double accommodationLatitude;
  final double accommodationLongitude;
  final String categoryCode;
  final int minPrice;

  final List<AccommodationImageModel>? accommodationImages;

  SearchAccommodationResponseModel({
    required this.accommodationId,
    required this.accommodationName,
    required this.accommodationAddress,
    required this.accommodationLatitude,
    required this.accommodationLongitude,
    required this.categoryCode,
    required this.minPrice,
    this.accommodationImages,
  });

  factory SearchAccommodationResponseModel.fromJson(Map<String, dynamic> json) {
    try {
      return SearchAccommodationResponseModel(
        accommodationId: json['accommodationId'] as int,
        accommodationName: json['accommodationName'] as String,
        accommodationAddress: json['accommodationAddress'] as String,
        accommodationLatitude:
        (json['accommodationLatitude'] as num?)!.toDouble(),
        accommodationLongitude:
        (json['accommodationLongitude'] as num?)!.toDouble(),
        categoryCode: json['categoryCode'] as String,
        minPrice: json['minPrice'] as int,
        accommodationImages: json['accommodationImages'] != null
            ? (json['accommodationImages'] as List<dynamic>)
            .map((e) =>
            AccommodationImageModel.fromJson(e as Map<String, dynamic>))
            .toList()
            : null,
      );
    } catch (e, stackTrace) {
      print('Accommodation.fromJson 실패: $e');
      print(stackTrace);
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'accommodationId': accommodationId,
      'accommodationName': accommodationName,
      'accommodationAddress': accommodationAddress,
      'accommodationLatitude': accommodationLatitude,
      'accommodationLongitude': accommodationLongitude,
      'categoryCode': categoryCode,
      'minPrice': minPrice,
      'accommodationImages':
      accommodationImages?.map((e) => e.toJson()).toList(),
    };
  }
}
