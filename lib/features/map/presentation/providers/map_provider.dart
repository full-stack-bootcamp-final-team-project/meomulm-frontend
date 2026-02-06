import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/error/app_exception.dart';
import 'package:meomulm_frontend/features/accommodation/data/models/search_accommodation_response_model.dart';
import 'package:meomulm_frontend/features/map/data/datasources/map_service.dart';

/// 지도 기반 숙소 검색 상태와 선택 상태를 관리하는 프로바이더
class MapProvider extends ChangeNotifier {
  final MapService _service = MapService();

  List<SearchAccommodationResponseModel> _accommodations = [];
  bool _isLoading = false;
  bool _isSearching = false;
  AppException? _error;
  SearchAccommodationResponseModel? _selectedAccommodation;

  double? _lastLatitude;
  double? _lastLongitude;

  // =====================
  // Getters
  // =====================
  List<SearchAccommodationResponseModel> get accommodations => _accommodations;

  bool get isLoading => _isLoading;

  bool get isSearching => _isSearching;

  AppException? get error => _error;

  SearchAccommodationResponseModel? get selectedAccommodation =>
      _selectedAccommodation;

  /// 검색 결과가 있는 상태
  bool get hasResult => _accommodations.isNotEmpty;

  /// 검색은 끝났지만 결과가 없는 상태
  bool get isEmptyResult =>
      !_isLoading && _accommodations.isEmpty && _error == null;

  // =====================
  // Actions
  // =====================

  /// 숙소 선택/해제
  void selectAccommodation(SearchAccommodationResponseModel? accommodation) {
    _selectedAccommodation = accommodation;
    notifyListeners();
  }

  /// 위도/경도로 숙소 검색 (필터 파라미터 추가)
  Future<void> searchByLocation({
    required double latitude,
    required double longitude,
    Map<String, dynamic>? filterParams,
  }) async {
    // 동일 위치 검색 스킵 (필터가 있으면 무조건 검색)
    if (filterParams == null && _isSameLocation(latitude, longitude)) {
      debugPrint('동일한 위치 검색 스킵');
      return;
    }

    // 중복 호출 차단
    if (_isSearching) {
      debugPrint('검색 중복 호출 차단');
      return;
    }
    _isSearching = true;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // MapService에 개별 파라미터로 전달
      final result = await _service.getAccommodationByLocation(
        latitude: latitude,
        longitude: longitude,
        filterParams: filterParams,
      );

      _accommodations = result;
      _lastLatitude = latitude;
      _lastLongitude = longitude;

      // 선택된 숙소가 결과에 없으면 해제
      if (_selectedAccommodation != null) {
        final stillExists = result.any(
          (acc) =>
              acc.accommodationId == _selectedAccommodation!.accommodationId,
        );
        if (!stillExists) {
          _selectedAccommodation = null;
        }
      }
    } on AppException catch (e) {
      // 백엔드에서 온 에러를 그대로 저장
      _error = e;
      debugPrint('MapProvider 검색 에러: [${e.code}] ${e.message}');
    } catch (e, stack) {
      // 예상치 못한 에러
      _error = AppException(
        status: 0,
        code: 'UNEXPECTED_ERROR',
        message: '숙소를 불러오는데 실패했습니다.',
      );
      debugPrint('MapProvider 검색 에러: $e');
      debugPrintStack(stackTrace: stack);
    } finally {
      _isLoading = false;
      _isSearching = false;
      notifyListeners();
    }
  }

  /// 재시도
  Future<void> retry({Map<String, dynamic>? filterParams}) async {
    if (_lastLatitude != null && _lastLongitude != null) {
      final lat = _lastLatitude!;
      final lng = _lastLongitude!;
      _lastLatitude = null;
      _lastLongitude = null;

      await searchByLocation(
        latitude: lat,
        longitude: lng,
        filterParams: filterParams,
      );
    }
  }

  /// 같은 위치인지 확인
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
    _isSearching = false;
    _lastLatitude = null;
    _lastLongitude = null;
    _selectedAccommodation = null;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
