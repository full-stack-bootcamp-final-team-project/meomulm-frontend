class ProductFacility {
  final int productFacilityId;
  final int? productId;
  final bool hasBath;
  final bool hasAirCondition;
  final bool hasRefrigerator;
  final bool hasBidet;
  final bool hasTv;
  final bool hasPc;
  final bool hasInternet;
  final bool hasToiletries;



  ProductFacility({
    required this.productFacilityId,
    this.productId,
    required this.hasBath,
    required this.hasAirCondition,
    required this.hasRefrigerator,
    required this.hasBidet,
    required this.hasTv,
    required this.hasPc,
    required this.hasInternet,
    required this.hasToiletries,

  });

  factory ProductFacility.fromJson(Map<String, dynamic> json) {
    try {
      return ProductFacility(
        productFacilityId: json['productFacilityId'] as int,
        productId: json['productId'] as int?,
        hasBath: json['hasBath'] as bool,
        hasAirCondition: json['hasAirCondition'] as bool,
        hasRefrigerator: json['hasRefrigerator'] as bool,
        hasBidet: json['hasBidet'] as bool,
        hasTv: json['hasTv'] as bool,
        hasPc: json['hasPc'] as bool,
        hasInternet: json['hasInternet'] as bool,
        hasToiletries: json['hasToiletries'] as bool,
      );
    } catch (e) {
      throw Exception('Result.fromJson 파싱 실패: $e\nJSON: $json');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'productFacilityId': productFacilityId,
      'productId': productId,
      'hasBath': hasBath,
      'hasAirCondition': hasAirCondition,
      'hasRefrigerator': hasRefrigerator,
      'hasBidet': hasBidet,
      'hasTv': hasTv,
      'hasPc': hasPc,
      'hasInternet': hasInternet,
      'hasToiletries': hasToiletries,
    };
  }

}


