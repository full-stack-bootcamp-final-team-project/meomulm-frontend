import 'package:flutter/material.dart';

class AccommodationProvider extends ChangeNotifier {
  String? _accommodationName;
  String? _locationName;

  DateTimeRange _dateRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now().add(const Duration(days: 1)),
  );

  int _guestCount = 2;


  int? _selectedAccommodationId;
  String? _selectedAccommodationName;




  // Getter
  String? get accommodationName => _accommodationName;
  String? get locationName => _locationName;
  DateTimeRange get dateRange => _dateRange;
  DateTime get checkIn => _dateRange.start;
  DateTime get checkOut => _dateRange.end;
  int get guestCount => _guestCount;
  int? get selectedAccommodationId => _selectedAccommodationId;
  String? get selectedAccommodationName => _selectedAccommodationName;



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


  void setAccommodation(int id, String name) {
    _selectedAccommodationId = id;
    _selectedAccommodationName = name;
    notifyListeners();
  }






  void clearAccommodation() {
    _selectedAccommodationId = null;
    _selectedAccommodationName = null;
    notifyListeners();
  }


  void clearAccommodationName() {
    _accommodationName = null;
    notifyListeners();
  }

  void clearSearchData() {
    _accommodationName = null;
    _locationName = null;
    _dateRange = DateTimeRange(
        start: DateTime.now(),
        end: DateTime.now().add(const Duration(days: 1))
    );
    _guestCount = 2;
    notifyListeners();
  }
}