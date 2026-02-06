import 'package:meomulm_frontend/features/accommodation/data/models/search_accommodation_response_model.dart';
import 'package:meomulm_frontend/features/my_page/data/models/select_favorite_model.dart';

/// 숙소 이미지 관련 유틸리티
class AccommodationImageUtils {
  AccommodationImageUtils._();

  /// 이미지가 없는 경우 accommodationId 기반으로 일관된 기본 이미지 선택
  static String getImageUrl(SearchAccommodationResponseModel accommodation) {
    // 네트워크 이미지가 있는 경우
    if (accommodation.accommodationImages != null &&
        accommodation.accommodationImages!.isNotEmpty) {
      return accommodation.accommodationImages!.first.accommodationImageUrl;
    }

    // 기본 이미지 선택 (1~3 중 하나, accommodationId 기반으로 일관성 유지)
    return getDefaultImagePath(accommodation.accommodationId);
  }

  /// 찜 목록(Favorite) 전용
  static String getImageUrlFromFavorite(SelectFavoriteModel favorite) {
    // 네트워크 이미지가 있는 경우
    if (favorite.accommodationImageUrl != null && favorite.accommodationImageUrl!.isNotEmpty) {
      return favorite.accommodationImageUrl!;
    }

    // 기본 이미지 선택
    return getDefaultImagePath(favorite.accommodationId);
  }

  /// accommodationId 기반으로 기본 이미지 경로 반환
  static String getDefaultImagePath(int accommodationId) {
    final imageIndex = (accommodationId % 3) + 1;
    return 'assets/images/accommodation/default_accommodation_image($imageIndex).jpg';
  }

  /// URL이 네트워크 이미지인지 확인
  static bool isNetworkImage(String url) {
    return url.startsWith('http://') || url.startsWith('https://');
  }
}