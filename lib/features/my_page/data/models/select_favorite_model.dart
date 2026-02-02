class SelectFavoriteModel {
  final int favoriteId;
  final int userId;
  final int accommodationId;
  final String createdAt;

  final String accommodationName;
  final String accommodationAddress;
  final String? accommodationImageUrl;

  SelectFavoriteModel({
    required this.favoriteId,
    required this.userId,
    required this.accommodationId,
    required this.createdAt,
    required this.accommodationName,
    required this.accommodationAddress,
    this.accommodationImageUrl,
  });

  factory SelectFavoriteModel.fromJson(Map<String, dynamic> json) {
    try {
      return SelectFavoriteModel(
        favoriteId: json['favoriteId'] as int,
        userId: json['userId'] as int,
        accommodationId: json['accommodationId'] as int,
        createdAt: json['createdAt'] as String,
        accommodationName: json['accommodationName'] as String,
        accommodationAddress: json['accommodationAddress'] as String,
        accommodationImageUrl: json['accommodationImageUrl'] as String?,
      );
    } catch (e, stackTrace) {
      print('Favorite.fromJson 실패: $e');
      print(stackTrace);
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'favoriteId': favoriteId,
      'userId': userId,
      'accommodationId': accommodationId,
      'createdAt': createdAt,
      'accommodationName': accommodationName,
      'accommodationAddress': accommodationAddress,
      'accommodationImageUrl': accommodationImageUrl,
    };
  }
}
