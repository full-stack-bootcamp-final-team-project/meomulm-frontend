import 'package:flutter/material.dart';
import 'package:meomulm_frontend/features/accommodation/data/models/search_accommodation_response_model.dart';
import 'package:meomulm_frontend/features/map/data/datasources/map_service.dart';

class MapProvider extends ChangeNotifier {
  final MapService _service = MapService();

  List<SearchAccommodationResponseModel> _accommodations = [];
  bool _isLoading = false;
  String? _error;

  // 👇 추가: 선택된 숙소
  SearchAccommodationResponseModel? _selectedAccommodation;

  // 마지막 검색 위치 저장 (중복 검색 방지)
  double? _lastLatitude;
  double? _lastLongitude;

  // =====================
  // getters
  // =====================
  List<SearchAccommodationResponseModel> get accommodations => _accommodations;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // 👇 추가
  SearchAccommodationResponseModel? get selectedAccommodation => _selectedAccommodation;

  /// 검색 결과가 있는 상태
  bool get hasResult => _accommodations.isNotEmpty;

  /// 검색은 끝났지만 결과가 없는 상태
  bool get isEmptyResult =>
      !_isLoading && _accommodations.isEmpty && _error == null;

  // =====================
  // actions
  // =====================

  // 👇 추가: 숙소 선택/해제
  void selectAccommodation(SearchAccommodationResponseModel? accommodation) {
    _selectedAccommodation = accommodation;
    notifyListeners();
  }

  /// 위도/경도로 숙소 검색
  Future<void> searchByLocation({
    required double latitude,
    required double longitude,
  }) async {
    // 이미 로딩 중이면 무시
    if (_isLoading) return;

    // 동일한 위치 재검색 방지 (소수점 4자리까지 비교)
    if (_isSameLocation(latitude, longitude)) {
      debugPrint('동일한 위치 검색 스킵');
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _service.getAccommodationByLocation(
        latitude: latitude,
        longitude: longitude,
      );

      _accommodations = result;
      _lastLatitude = latitude;
      _lastLongitude = longitude;

      // 👇 추가: 검색 시 선택 초기화
      _selectedAccommodation = null;

    } catch (e, stack) {
      _error = '숙소를 불러오는데 실패했습니다.';
      debugPrint('MapProvider 검색 에러: $e');
      debugPrintStack(stackTrace: stack);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 동일 위치 확인 (소수점 4자리 비교 - 약 11m 정확도)
  bool _isSameLocation(double latitude, double longitude) {
    if (_lastLatitude == null || _lastLongitude == null) {
      return false;
    }

    return (_lastLatitude! - latitude).abs() < 0.0001 &&
        (_lastLongitude! - longitude).abs() < 0.0001;
  }

  /// 상태 초기화 (화면 이탈, 새 검색 시작 등)
  void clear() {
    _accommodations = [];
    _error = null;
    _isLoading = false;
    _lastLatitude = null;
    _lastLongitude = null;
    _selectedAccommodation = null; // 👈 추가
    notifyListeners();
  }

  @override
  void dispose() {
    _service.dispose(); // MapService의 Dio 인스턴스 정리
    super.dispose();
  }
}