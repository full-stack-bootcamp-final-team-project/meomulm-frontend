import 'product_model.dart';

class ProductResponse {
  final List<Product>? allProducts;
  final List<int>? availableProductIds; // 수정: List<int>

  ProductResponse({
    this.allProducts,
    this.availableProductIds,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      allProducts: json['allProducts'] != null
          ? (json['allProducts'] as List)
          .map((e) => Product.fromJson(e))
          .toList()
          : null,
      availableProductIds: json['availableProductIds'] != null
          ? List<int>.from(json['availableProductIds'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'allProducts': allProducts?.map((e) => e.toJson()).toList(),
      'availableProductIds': availableProductIds,
    };
  }
}
