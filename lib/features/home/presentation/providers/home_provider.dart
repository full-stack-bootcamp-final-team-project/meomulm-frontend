import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:meomulm_frontend/features/accommodation/data/datasources/home_accommodation_service.dart';
import 'package:meomulm_frontend/features/accommodation/data/models/search_accommodation_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeProvider with ChangeNotifier {
  final HomeAccommodationService _service;

  HomeProvider(this._service);

  bool isLoading = false;

  // 최근 본 숙소
  List<SearchAccommodationResponseModel> recentList = [];

  // HOT 영역
  List<SearchAccommodationResponseModel> seoulList = [];
  List<SearchAccommodationResponseModel> busanList = [];
  List<SearchAccommodationResponseModel> jejuList = [];

  // 홈 화면 데이터 불러오기
  Future<void> loadHome({String? token}) async {

    isLoading = true;
    notifyListeners();

    try {
      // 지역 별 HOT 숙소
      final results = await Future.wait([
        _service.getAccommodationPopularByAddress('서울'),
        _service.getAccommodationPopularByAddress('부산'),
        _service.getAccommodationPopularByAddress('제주'),
      ]);

      seoulList = results[0];
      busanList = results[1];
      jejuList = results[2];

      // 최근 본 숙소
      recentList = await _loadRecentFromLocal();
    } catch (e) {
      debugPrint('Home load 실패: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 최근 본 숙소 불러오기
  Future<List<SearchAccommodationResponseModel>> _loadRecentFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList('recent_accommodations') ?? [];
    final recentAccom = jsonList
        .map((e) => SearchAccommodationResponseModel.fromJson(jsonDecode(e)))
        .toList();

    return recentAccom;
  }

  // 최근 본 숙소 추가
  Future<void> addRecentAccommodation(SearchAccommodationResponseModel accom) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getStringList('recent_accommodations') ?? [];

    // 중복 제거
    current.removeWhere((e) {
      final item = SearchAccommodationResponseModel.fromJson(jsonDecode(e));
      return item.accommodationId == (accom.accommodationId ?? '');
    });

    // 맨 앞에 추가
    current.insert(0, jsonEncode(accom.toJson()));

    // 최대 12개 유지
    if (current.length > 12) current.removeLast();

    await prefs.setStringList('recent_accommodations', current);

    // Provider 업데이트
    recentList = current.map((e) => SearchAccommodationResponseModel.fromJson(jsonDecode(e))).toList();

    notifyListeners();
  }
}
