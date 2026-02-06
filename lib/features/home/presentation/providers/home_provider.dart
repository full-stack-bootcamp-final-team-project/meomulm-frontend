import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:meomulm_frontend/features/accommodation/data/datasources/home_accommodation_service.dart';
import 'package:meomulm_frontend/features/accommodation/data/datasources/accommodation_api_service.dart';
import 'package:meomulm_frontend/features/accommodation/data/models/search_accommodation_response_model.dart';

class HomeProvider with ChangeNotifier {
  // 인기 숙소 조회

  final HomeAccommodationService _homeService = HomeAccommodationService() ;
  // 최근 본 숙소 조회
  final AccommodationApiService _accommodationService = AccommodationApiService();

  bool isLoading = false;

  /// 최근 본 숙소 (서버 응답 그대로)
  List<SearchAccommodationResponseModel> recentList = [];

  /// HOT 지역별 숙소
  List<SearchAccommodationResponseModel> seoulList = [];
  List<SearchAccommodationResponseModel> busanList = [];
  List<SearchAccommodationResponseModel> jejuList = [];

  /// 홈 전체 로드
  Future<void> loadHome({required bool isLoggedIn}) async {
    isLoading = true;
    notifyListeners();

    try {
      final results = await Future.wait([
        _homeService.getAccommodationPopularByAddress('서울'),
        _homeService.getAccommodationPopularByAddress('부산'),
        _homeService.getAccommodationPopularByAddress('제주'),
      ]);

      seoulList = results[0];
      busanList = results[1];
      jejuList = results[2];

      await loadRecentFromLocal(isLoggedIn: isLoggedIn);
    } catch (e) {
      debugPrint('Home load 실패: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// 최근 본 숙소 ID 저장 + 리스트 갱신
  Future<void> addRecentAccommodationId(
      int id,
      {required bool isLoggedIn}
    ) async {
    if (!isLoggedIn) return;
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList('recent_ids') ?? [];

    ids.remove(id.toString()); // 중복 제거
    ids.insert(0, id.toString()); // 가장 최근 본 숙소를 맨 앞에 삽입

    if (ids.length > 12) ids.removeLast(); // 최대 12개

    await prefs.setStringList('recent_ids', ids);

    // 로컬 -> 서버 조회 후 recentList 갱신
    await loadRecentFromLocal(isLoggedIn: true);
  }

  /// 최근 본 숙소 서버 조회
  Future<void> loadRecentFromLocal({required bool isLoggedIn}) async {
    // 비로그인 → 최근 본 숙소 안 씀
    if (!isLoggedIn) {
    recentList = [];
    notifyListeners();
    return;
    }

    final prefs = await SharedPreferences.getInstance();
    // 아이디 리스트
    final ids = prefs.getStringList('recent_ids') ?? [];

    if (ids.isEmpty) {
      recentList = [];
      notifyListeners();
      return;
    }

    final idList = ids.map(int.parse).toList();

    final responses = await _accommodationService.getRecentAccommodations(idList);
    // 데이터 순서대로 정렬
    responses.sort((a, b) => idList.indexOf(a.accommodationId) - idList.indexOf(b.accommodationId));
    // 서버 API 호출
    recentList = responses;

    notifyListeners();
  }
}
