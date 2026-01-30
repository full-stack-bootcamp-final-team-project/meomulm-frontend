import 'package:geolocator/geolocator.dart';
import 'package:kakao_map_sdk/kakao_map_sdk.dart';
import 'package:meomulm_frontend/features/accommodation/data/models/search_accommodation_response_model.dart';

class MapMarkerManager {
  final KakaoMapController controller;
  final List<Poi> _accommodationPois = [];
  Poi? _myLocationPoi;

  MapMarkerManager(this.controller);

  // 모든 마커 제거
  Future<void> clearAll() async {
    // 숙소 마커 제거
    for (final poi in _accommodationPois) {
      await poi.remove();
    }
    _accommodationPois.clear();

    // 내 위치 마커 제거
    await _myLocationPoi?.remove();
    _myLocationPoi = null;
  }

  // 내 위치 마커 추가
  Future<void> addMyLocationMarker(Position position) async {
    _myLocationPoi = await controller.labelLayer.addPoi(
      LatLng(position.latitude, position.longitude),
      style: PoiStyle(),
    );
  }

  // 숙소 마커 추가
  Future<void> addAccommodationMarkers(List<SearchAccommodationResponseModel> accommodations) async {
    for (final acc in accommodations) {
      if (acc.accommodationLatitude == null ||
          acc.accommodationLongitude == null) continue;

      final poi = await controller.labelLayer.addPoi(
        LatLng(
          acc.accommodationLatitude!,
          acc.accommodationLongitude!,
        ),
        style: PoiStyle(),
      );

      _accommodationPois.add(poi);
    }
  }

  // 모든 마커 갱신 (내 위치 + 숙소)
  Future<void> updateMarkers({
    Position? myPosition,
    required List<SearchAccommodationResponseModel> accommodations,
  }) async {
    await clearAll();

    if (myPosition != null) {
      await addMyLocationMarker(myPosition);
    }

    await addAccommodationMarkers(accommodations);
  }
}
