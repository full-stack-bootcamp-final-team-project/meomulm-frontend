import 'package:flutter/material.dart';

/// 숙소 필터 상태 관리
class FilterProvider extends ChangeNotifier {
  // 필터 상태
  Set<String> _selectedFacilities = {};
  Set<String> _selectedTypes = {};
  RangeValues _priceRange = const RangeValues(0, 200);

  // Getters
  Set<String> get facilities => _selectedFacilities;
  Set<String> get types => _selectedTypes;
  RangeValues get priceRange => _priceRange;

  // Mapping
  static const Map<String, String> _facilityMapping = {
    '주차장': 'has_parking',
    '전기차 충전': 'has_ev_charging',
    '흡연구역': 'has_smoking_area',
    '공용 와이파이': 'has_public_wifi',
    '레저 시설': 'has_leisure',
    '운동 시설': 'has_sports',
    '쇼핑 시설': 'has_shopping',
    '회의 시설': 'has_business',
    '레스토랑': 'has_fnb',
  };

  static const Map<String, String> _typeMapping = {
    '호텔': 'HOTEL',
    '리조트': 'RESORT',
    '펜션': 'PENSION',
    '모텔': 'MOTEL',
    '게스트하우스': 'GUESTHOUSE',
    '글램핑': 'GLAMPING',
    '카라반': 'CARAVAN',
    '캠핑': 'CAMPING',
    '캠프닉': 'CAMPNIC',
    '오토캠핑': 'AUTO_CAMPING',
    '기타': 'ETC',
  };

  /// API 파라미터 생성
  Map<String, dynamic> get filterParams {
    final params = <String, dynamic>{};

    if (_selectedFacilities.isNotEmpty) {
      params['facilities'] = _selectedFacilities
          .map((f) => _facilityMapping[f])
          .whereType<String>()
          .toList();
    }

    if (_selectedTypes.isNotEmpty) {
      params['types'] = _selectedTypes
          .map((t) => _typeMapping[t])
          .whereType<String>()
          .toList();
    }

    params['minPrice'] = (_priceRange.start * 10000).toInt();
    params['maxPrice'] = (_priceRange.end * 10000).toInt();

    return params;
  }

  /// 필터가 적용되었는지 확인
  bool get hasActiveFilters {
    return _selectedFacilities.isNotEmpty ||
        _selectedTypes.isNotEmpty ||
        _priceRange.start != 0 ||
        _priceRange.end != 200;
  }

  /// 적용된 필터 개수
  int get activeFilterCount {
    int count = 0;
    if (_selectedFacilities.isNotEmpty) count++;
    if (_selectedTypes.isNotEmpty) count++;
    if (_priceRange.start != 0 || _priceRange.end != 200) count++;
    return count;
  }

  // Actions
  void toggleFacility(String value) {
    _selectedFacilities.contains(value)
        ? _selectedFacilities.remove(value)
        : _selectedFacilities.add(value);
    notifyListeners();
  }

  void toggleType(String value) {
    _selectedTypes.contains(value)
        ? _selectedTypes.remove(value)
        : _selectedTypes.add(value);
    notifyListeners();
  }

  void setPriceRange(RangeValues values) {
    _priceRange = values;
    notifyListeners();
  }

  void resetFilters() {
    _selectedFacilities.clear();
    _selectedTypes.clear();
    _priceRange = const RangeValues(0, 200);
    notifyListeners();
  }
}