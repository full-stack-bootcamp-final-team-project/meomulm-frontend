import 'package:flutter/material.dart';

class AccommodationProvider extends ChangeNotifier {
  String? _currentAccommodationId;
  String? get currentId => _currentAccommodationId;

  void setCurrentId(String id) {
    _currentAccommodationId = id;
    notifyListeners();
  }

  void clear() {
    _currentAccommodationId = null;
  }
}