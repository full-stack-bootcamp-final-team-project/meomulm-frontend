import 'package:flutter/material.dart';
import 'package:kakao_map_sdk/kakao_map_sdk.dart';
import 'package:meomulm_frontend/features/accommodation/data/models/search_accommodation_response_model.dart';
import 'package:meomulm_frontend/features/map/presentation/utils/map_marker_manager.dart';

/// 현재 위치와 숙소 목록의 변경 여부를 감지하여 지도 마커 업데이트를 제어하는 컨트롤러
class MapMarkerController {
  final MapMarkerManager _markerManager;

  LatLng? _lastMyPosition;
  List<SearchAccommodationResponseModel> _lastAccommodations = [];

  MapMarkerController(KakaoMapController mapController)
    : _markerManager = MapMarkerManager(mapController);

  /// 마커 업데이트
  Future<void> update({
    LatLng? myPosition,
    required List<SearchAccommodationResponseModel> accommodations,
    ValueChanged<SearchAccommodationResponseModel>? onMarkerTap,
  }) async {
    final myPositionChanged = _isPositionChanged(_lastMyPosition, myPosition);
    final accommodationsChanged = _isAccommodationsChanged(
      _lastAccommodations,
      accommodations,
    );

    if (!myPositionChanged && !accommodationsChanged) {
      return;
    }

    await _markerManager.updateMarkers(
      myPosition: myPosition,
      accommodations: accommodations,
      onMarkerTap: onMarkerTap,
    );

    _lastMyPosition = myPosition;
    _lastAccommodations = accommodations;
  }

  /// 위치 변경 여부 확인
  bool _isPositionChanged(LatLng? oldPosition, LatLng? newPosition) {
    if (oldPosition == null && newPosition == null) return false;
    if (oldPosition == null || newPosition == null) return true;

    return oldPosition.latitude != newPosition.latitude ||
        oldPosition.longitude != newPosition.longitude;
  }

  /// 숙소 리스트 변경 여부 확인 (개선 버전)
  bool _isAccommodationsChanged(
    List<SearchAccommodationResponseModel> oldList,
    List<SearchAccommodationResponseModel> newList,
  ) {
    if (oldList.length != newList.length) return true;

    final oldIds = oldList.map((e) => e.accommodationId).toSet();
    final newIds = newList.map((e) => e.accommodationId).toSet();

    return oldIds.difference(newIds).isNotEmpty;
  }

  Future<void> dispose() async {
    await _markerManager.dispose();
  }
}
