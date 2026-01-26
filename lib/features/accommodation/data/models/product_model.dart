import 'package:meomulm_frontend/features/accommodation/data/models/product_facility_model.dart';
import 'package:meomulm_frontend/features/accommodation/data/models/product_image_model.dart';

class Product {
  final int productId;
  final int? accommodationId;
  final String? productName;
  final String? productCheckInTime;
  final String? productCheckOutTime;
  final int? productPrice;
  final int? productStandardNumber;
  final int? productMaximumNumber;
  final int? productCount;

  ProductFacility? facility; // 추가
  List<ProductImage>? images;



  Product({
    required this.productId,
    this.accommodationId,
    this.productName,
    this.productCheckInTime,
    this.productCheckOutTime,
    this.productPrice,
    this.productStandardNumber,
    this.productMaximumNumber,
    this.productCount,

    this.facility,
    this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    try {
      return Product(
        productId: json['productId'] as int,
        accommodationId: json['accommodationId'] as int?,
        productName: json['productName'] as String?,
        productCheckInTime: json['productCheckInTime'] as String?,
        productCheckOutTime: json['productCheckOutTime'] as String?,
        productPrice: json['productPrice'] as int?,
        productStandardNumber: json['productStandardNumber'] as int?,
        productMaximumNumber: json['productMaximumNumber'] as int?,
        productCount: json['productCount'] as int?,

        facility: json['facility'] != null
            ? ProductFacility.fromJson(json['facility'])
            : null,
        images: json['images'] != null
            ? (json['images'] as List)
            .map((e) => ProductImage.fromJson(e))
            .toList()
            : null,
      );
    } catch (e) {
      throw Exception('Result.fromJson 파싱 실패: $e\nJSON: $json');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'accommodationId': accommodationId,
      'productName': productName,
      'productCheckInTime': productCheckInTime,
      'productCheckOutTime': productCheckOutTime,
      'productPrice': productPrice,
      'productStandardNumber': productStandardNumber,
      'productMaximumNumber': productMaximumNumber,
      'productCount': productCount,

      'facility': facility?.toJson(),
      'images': images?.map((e) => e.toJson()).toList(),
    };
  }

}
