import 'package:flutter/material.dart';

class AccommodationProvider extends ChangeNotifier {
  String? _accommodationName;
  String? _locationName;

  DateTimeRange _dateRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now().add(const Duration(days: 1)),
  );

  int _guestCount = 2;
  String? _accommodationId;



  // Getter
  String? get accommodationName => _accommodationName;
  String? get locationName => _locationName;
  DateTimeRange get dateRange => _dateRange;
  DateTime get checkIn => _dateRange.start;
  DateTime get checkOut => _dateRange.end;
  int get guestCount => _guestCount;
  String? get accommodationId => _accommodationId;



  // Setter
  void setAccommodationSearch({
    String? accommodationName,
    DateTimeRange? dateRange,
    int? guestCount
  }) {
    bool updated = false;

    if (accommodationName != null && accommodationName != _accommodationName) {
      _accommodationName = accommodationName;
      updated = true;
    }

    if (dateRange != null && dateRange != _dateRange) {
      _dateRange = dateRange;
      updated = true;
    }

    if (guestCount != null && guestCount != _guestCount) {
      _guestCount = guestCount;
      updated = true;
    }

    if (updated) notifyListeners();
  }

  void setMapSearch({
    String? locationName,
    DateTimeRange? dateRange,
    int? guestCount
  }) {
    bool updated = false;

    if (locationName != null && locationName != _locationName) {
      _locationName = locationName;
      updated = true;
    }

    if (dateRange != null && dateRange != _dateRange) {
      _dateRange = dateRange;
      updated = true;
    }

    if (guestCount != null && guestCount != _guestCount) {
      _guestCount = guestCount;
      updated = true;
    }

    if (updated) notifyListeners();
  }


  void setDateRange(DateTimeRange range) {
    _dateRange = range;
    notifyListeners();
  }


  void setGuestCount(int count) {
    _guestCount = count;
    notifyListeners();
  }


  void setAccommodationId(String id) {
    _accommodationId = id;
    notifyListeners();
  }


  void clearAccommodationId() {
    _accommodationId = null;
  }

  void clearSearchData() {
    _accommodationName = null;
    _locationName = null;
    _dateRange = DateTimeRange(
        start: DateTime.now(),
        end: DateTime.now().add(const Duration(days: 1))
    );
    _guestCount = 2;
  }
}