
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccommodationFilterProvider extends ChangeNotifier {
  final Set<String> facilities = {};
  final Set<String> types = {};

  RangeValues priceRange = const RangeValues(0, 480);

  void toggleFacility(String value) {
    facilities.contains(value)
        ? facilities.remove(value)
        : facilities.add(value);
    notifyListeners();
  }

  void toggleType(String value) {
    types.contains(value) ? types.remove(value) : types.add(value);
    notifyListeners();
  }

  void setPrice(RangeValues values) {
    priceRange = values;
    notifyListeners();
  }

  void reset() {
    facilities.clear();
    types.clear();
    priceRange = const RangeValues(0, 480);
    notifyListeners();
  }

  Map<String, dynamic> toQuery() {
    return {
      'facilities': facilities.toList(),
      'types': types.toList(),
      'minPrice': priceRange.start.toInt(),
      'maxPrice': priceRange.end.toInt(),
    };
  }
}
