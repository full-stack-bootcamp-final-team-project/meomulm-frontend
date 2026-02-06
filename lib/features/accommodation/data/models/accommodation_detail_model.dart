class AccommodationDetailModel {
  final int accommodationId;
  final String accommodationName;
  final String accommodationAddress;
  final String accommodationPhone;
  final double accommodationLongitude;
  final double accommodationLatitude;
  final String contentId;

  // 편의시설 (boolean)
  final bool hasParking;
  final bool hasEvCharging;
  final bool hasSmokingArea;
  final bool hasPublicWifi;
  final bool hasLeisure;
  final bool hasSports;
  final bool hasShopping;
  final bool hasBusiness;
  final bool hasFnb;

  // 이미지 리스트
  final List<AccommodationImage> accommodationImages;

  AccommodationDetailModel({
    required this.accommodationId,
    required this.accommodationName,
    required this.accommodationAddress,
    required this.accommodationPhone,
    required this.accommodationLongitude,
    required this.accommodationLatitude,
    required this.contentId,
    required this.hasParking,
    required this.hasEvCharging,
    required this.hasSmokingArea,
    required this.hasPublicWifi,
    required this.hasLeisure,
    required this.hasSports,
    required this.hasShopping,
    required this.hasBusiness,
    required this.hasFnb,
    required this.accommodationImages,
  });

  factory AccommodationDetailModel.fromJson(Map<String, dynamic> json) {
    return AccommodationDetailModel(
      accommodationId: json['accommodationId'] ?? 0,
      accommodationName: json['accommodationName'] ?? '',
      accommodationAddress: json['accommodationAddress'] ?? '',
      accommodationPhone: json['accommodationPhone'] ?? '',
      accommodationLongitude: (json['accommodationLongitude'] as num?)?.toDouble() ?? 0.0,
      accommodationLatitude: (json['accommodationLatitude'] as num?)?.toDouble() ?? 0.0,
      contentId: json['contentId'] ?? '',
      hasParking: json['hasParking'] ?? false,
      hasEvCharging: json['hasEvCharging'] ?? false,
      hasSmokingArea: json['hasSmokingArea'] ?? false,
      hasPublicWifi: json['hasPublicWifi'] ?? false,
      hasLeisure: json['hasLeisure'] ?? false,
      hasSports: json['hasSports'] ?? false,
      hasShopping: json['hasShopping'] ?? false,
      hasBusiness: json['hasBusiness'] ?? false,
      hasFnb: json['hasFnb'] ?? false,
      accommodationImages: (json['accommodationImages'] as List<dynamic>?)
          ?.map((e) => AccommodationImage.fromJson(e))
          .toList() ??
          [],
    );
  }

  // 이미지 URL 추출 헬퍼 getter
  List<String> get imageUrls {
    return accommodationImages
        .map((img) => img.accommodationImageUrl)
        .where((url) => url.isNotEmpty)
        .toList();
  }

  // UI에서 편의시설 리스트를 뽑아내기 위한 헬퍼 메서드
  List<String> get serviceLabels {
    final services = <String>[];
    if (hasParking) services.add('주차 가능');
    if (hasEvCharging) services.add('전기차 충전');
    if (hasSmokingArea) services.add('흡연 구역');
    if (hasPublicWifi) services.add('공용 와이파이');
    if (hasLeisure) services.add('레저 시설');
    if (hasSports) services.add('스포츠 시설');
    if (hasShopping) services.add('쇼핑');
    if (hasBusiness) services.add('비즈니스');
    if (hasFnb) services.add('식음료');
    return services;
  }
}

class AccommodationImage {
  final int accommodationImageId;
  final int accommodationId;
  final String accommodationImageUrl;

  AccommodationImage({
    required this.accommodationImageId,
    required this.accommodationId,
    required this.accommodationImageUrl,
  });

  factory AccommodationImage.fromJson(Map<String, dynamic> json) {
    return AccommodationImage(
      accommodationImageId: json['accommodationImageId'] ?? 0,
      accommodationId: json['accommodationId'] ?? 0,
      accommodationImageUrl: json['accommodationImageUrl'] ?? '',
    );
  }
}


/*
{
  "accommodationId": 1301,
  "accommodationName": "호텔 라포레130 카라반 캠핑장",
  "accommodationAddress": "대구 달성군 가창면 가창동로4길 67 ",
  "accommodationPhone": "",
  "accommodationLongitude": 128.665911430858,
  "accommodationLatitude": 35.7824745594768,
  "contentId": "101284",
  "hasParking": true,
  "hasEvCharging": false,
  "hasSmokingArea": false,
  "hasPublicWifi": false,
  "hasLeisure": false,
  "hasSports": false,
  "hasShopping": true,
  "hasBusiness": false,
  "hasFnb": false,
  "accommodationImages": null
}
*/