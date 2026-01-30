import 'package:flutter/material.dart';
import 'package:meomulm_frontend/features/accommodation/data/models/search_accommodation_response_model.dart';
import 'package:meomulm_frontend/features/map/data/datasources/map_service.dart';

class MapProvider extends ChangeNotifier {
  final MapService _service = MapService();

  List<SearchAccommodationResponseModel> _accommodations = [];
  bool _isLoading = false;
  String? _error;

  // =====================
  // getters
  // =====================
  List<SearchAccommodationResponseModel> get accommodations => _accommodations;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// 검색 결과가 있는 상태
  bool get hasResult => _accommodations.isNotEmpty;

  /// 검색은 끝났지만 결과가 없는 상태
  bool get isEmptyResult =>
      !_isLoading && _accommodations.isEmpty && _error == null;

  // =====================
  // actions
  // =====================

  /// 위도/경도로 숙소 검색
  Future<void> searchByLocation({
    required double latitude,
    required double longitude,
  }) async {
    if (_isLoading) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _service.getAccommodationByLocation(
        latitude: latitude,
        longitude: longitude,
      );

      _accommodations = result;
    } catch (e, stack) {
      _error = '숙소를 불러오는데 실패했습니다.';
      debugPrint('MapProvider 검색 에러: $e');
      debugPrintStack(stackTrace: stack);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 상태 초기화 (화면 이탈, 새 검색 시작 등)
  void clear() {
    _accommodations = [];
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
