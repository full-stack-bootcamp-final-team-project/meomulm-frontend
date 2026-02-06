import 'package:flutter/material.dart';

class AccommodationProvider extends ChangeNotifier {
  // 검색 조건
  String? _keyword;
  String? _location;
  double? _latitude;
  double? _longitude;

  DateTimeRange _dateRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now().add(const Duration(days: 1)),
  );

  int _guestNumber = 2;

  // 선택된 숙소 정보
  int? _selectedAccommodationId;
  String? _selectedAccommodationName;

  // Getters
  String? get keyword => _keyword;
  String? get location => _location;
  double? get latitude => _latitude;
  double? get longitude => _longitude;
  DateTimeRange get dateRange => _dateRange;
  DateTime get checkIn => _dateRange.start;
  DateTime get checkOut => _dateRange.end;
  int get guestNumber => _guestNumber;
  int? get selectedAccommodationId => _selectedAccommodationId;
  String? get selectedAccommodationName => _selectedAccommodationName;

  /// 검색 기본 파라미터 (필터 제외)
  Map<String, dynamic> get searchParams {
    final params = <String, dynamic>{
      'keyword': _keyword,
      'latitude': _latitude,
      'longitude': _longitude,
      'checkIn': checkIn.toIso8601String(),
      'checkOut': checkOut.toIso8601String(),
      'guestNumber': _guestNumber,
    };

    params.removeWhere(
          (k, v) => v == null || (v is String && v.isEmpty),
    );

    return params;
  }

  // === 검색 조건 관련 Actions ===

  void setSearchDate({
    String? keywordValue,
    DateTimeRange? dateRangeValue,
    int? guestNumberValue,
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

  void resetKeyword() {
    _keyword = null;
    notifyListeners();
  }

  void resetSearchData() {
    _keyword = null;
    _location = null;
    _latitude = null;
    _longitude = null;
    _dateRange = DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now().add(const Duration(days: 1)),
    );
    _guestNumber = 2;
    notifyListeners();
  }

  // === 선택된 숙소 관련 Actions ===

  void setAccommodationInfo(int id, String name) {
    _selectedAccommodationId = id;
    _selectedAccommodationName = name;
    notifyListeners();
  }

  void clearSelectedAccommodation() {
    _selectedAccommodationId = null;
    _selectedAccommodationName = null;
    notifyListeners();
  }
}