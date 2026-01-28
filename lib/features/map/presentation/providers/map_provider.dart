// map_search_provider.dart
import 'package:flutter/material.dart';
import 'package:meomulm_frontend/features/map/data/datasources/map_service.dart';
import 'package:meomulm_frontend/features/map/data/models/accommodation.dart';
class MapProvider extends ChangeNotifier {
  final MapService _service = MapService();

  List<Accommodation> _accommodations = [];
  bool _isLoading = false;
  String? _error;

  List<Accommodation> get accommodations => _accommodations;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // 위도/경도로 검색
  Future<void> searchByLocation({
    required double latitude,
    required double longitude,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _accommodations = await _service.getAccommodationByLocation(
        latitude: latitude,
        longitude: longitude,
      );
    } catch (e) {
      _error = '숙소를 불러오는데 실패했습니다.';
      debugPrint('검색 에러: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _accommodations = [];
    _error = null;
    notifyListeners();
  }
}
