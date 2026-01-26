
class ProductImage {
  final int productImageId;
  final int? productId;
  final String productImageUrl;



  ProductImage({
    required this.productImageId,
    this.productId,
    required this.productImageUrl

  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    try {
      return ProductImage(
          productImageId: json['productImageId'] as int,
          productId: json['productId'] as int?,
          productImageUrl: json['productImageUrl'] as String
      );
    } catch (e) {
      throw Exception('Result.fromJson 파싱 실패: $e\nJSON: $json');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'productImageId': productImageId,
      'productId': productId,
      'productImageUrl': productImageUrl
    };
  }

}


