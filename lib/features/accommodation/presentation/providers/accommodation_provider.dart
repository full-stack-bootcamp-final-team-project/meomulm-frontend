import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccommodationProvider extends ChangeNotifier {


  // 필터링 매핑
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
  };


  // 상태 변수
  String? _keyword;
  String? _location;
  double? _latitude;
  double? _longitude;
  DateTimeRange _dateRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now().add(const Duration(days: 1)),
  );
  int _guestNumber = 2;
  int? _selectedAccommodationId;
  String? _selectedAccommodationName;

  // 필터 상태
  final Set<String> _selectedFacilities = {};
  final Set<String> _selectedTypes = {};
  RangeValues _priceRange = const RangeValues(0, 200);


  // Getters
  String? get keyword => _keyword;
  String? get location => _location;
  double? get latitude => _latitude;
  double? get longitude => _longitude;
  DateTimeRange get dateRange => _dateRange;
  DateTime get checkIn => _dateRange.start;
  DateTime get checkOut => _dateRange.end;
  int get guestNumber => _guestNumber;
  Set<String> get facilities => _selectedFacilities;
  Set<String> get types => _selectedTypes;
  RangeValues get priceRange => _priceRange;
  int? get selectedAccommodationId => _selectedAccommodationId;
  String? get selectedAccommodationName => _selectedAccommodationName;


  // API 파라미터 생성
  Map<String, dynamic> get searchParams {
    final Map<String, dynamic> params = {
      'keyword': _keyword,
      'latitude': _latitude,
      'longitude': _longitude,
      'facilities': _selectedFacilities.map((f) => _facilityMapping[f]).toList(),
      'types': _selectedTypes.map((t) => _typeMapping[t]).toList(),
      'minPrice': (_priceRange.start * 10000).toInt(), // 예: 50 -> 50,000
      'maxPrice': (_priceRange.end * 10000).toInt(),
    };

    // null / 빈 리스트는 제거 후 전송
    params.removeWhere((k, v) => v == null || (v is List && v.isEmpty) || (v is String && v.isEmpty));
    return params;
  }


  // setter
  // void setKeyword(String? keyword) {
  //   _keyword = keyword;
  //   notifyListeners();
  // }

  void setSearchDate({
    String? keywordValue,
    DateTimeRange? dateRangeValue,
    int? guestNumberValue
  }) {
    bool updated = false;

    if (keywordValue != null && keywordValue != _keyword) {
      _keyword = keywordValue;
      updated = true;
    }

    if (dateRangeValue != null && dateRangeValue != _dateRange) {
      _dateRange = dateRangeValue;
      updated = true;
    }

    if (guestNumberValue != null && guestNumberValue != _guestNumber) {
      _guestNumber = guestNumberValue;
      updated = true;
    }

    if (updated) notifyListeners();
  }


  void toggleFacility(String value) {
    _selectedFacilities.contains(value) ? _selectedFacilities.remove(value) : _selectedFacilities.add(value);
    notifyListeners();
  }

  void toggleType(String value) {
    _selectedTypes.contains(value) ? _selectedTypes.remove(value) : _selectedTypes.add(value);
    notifyListeners();
  }

  void setPrice(RangeValues values) {
    _priceRange = values;
    notifyListeners();
  }

  void setAccommodationInfo(int id, String name) {
    _selectedAccommodationId = id;
    _selectedAccommodationName = name;
    notifyListeners();
  }



  void resetKeyword() {
    _keyword = null;
    notifyListeners();
  }

  void resetFilters() {
    _selectedFacilities.clear();
    _selectedTypes.clear();
    _priceRange = const RangeValues(0, 200);
    notifyListeners();
  }

  void resetSearchData() {
    _keyword = null;
    _location = null;
    _dateRange = DateTimeRange(
        start: DateTime.now(),
        end: DateTime.now().add(const Duration(days: 1))
    );
    _guestNumber = 2;
    notifyListeners();
  }

  void resetAllData() {
    _keyword = null;
    _location = null;
    _dateRange = DateTimeRange(
        start: DateTime.now(),
        end: DateTime.now().add(const Duration(days: 1))
    );
    _guestNumber = 2;
    notifyListeners();
  }
}