import 'package:flutter/foundation.dart';
import 'package:kakao_map_sdk/kakao_map_sdk.dart';
import 'package:meomulm_frontend/features/accommodation/data/models/search_accommodation_response_model.dart';

class MapMarkerManager {
  final KakaoMapController controller;

  final List<Poi> _accommodationPois = [];
  Poi? _myLocationPoi;

  MapMarkerManager(this.controller);

  /* =======================
   * 마커 전체 제거
   * ======================= */
  Future<void> clearAll() async {
    try {
      // 숙소 마커 제거
      for (final poi in _accommodationPois) {
        try {
          await poi.remove();
        } catch (e) {
          debugPrint('숙소 마커 제거 실패: $e');
        }
      }
      _accommodationPois.clear();

      // 내 위치 마커 제거
      if (_myLocationPoi != null) {
        try {
          await _myLocationPoi!.remove();
        } catch (e) {
          debugPrint('내 위치 마커 제거 실패: $e');
        } finally {
          _myLocationPoi = null;
        }
      }
    } catch (e) {
      debugPrint('마커 전체 제거 중 오류: $e');
    }
  }

  /* =======================
   * 내 위치 마커
   * ======================= */
  Future<void> addMyLocationMarker(LatLng position) async {
    try {
      _myLocationPoi = await controller.labelLayer.addPoi(
        position,
        style: PoiStyle(
          icon: KImage.fromAsset('assets/markers/my_location.png', 34, 50),
        ),
      );
    } catch (e) {
      debugPrint('내 위치 마커 추가 실패: $e');
      rethrow;
    }
  }

  /* =======================
   * 숙소 마커 추가
   * ======================= */
  Future<void> addAccommodationMarkers(
      List<SearchAccommodationResponseModel> accommodations,
      ValueChanged<SearchAccommodationResponseModel>? onMarkerTap, // 👈 추가
      ) async {
    int successCount = 0;
    int failCount = 0;

    for (final acc in accommodations) {
      try {
        final poi = await controller.labelLayer.addPoi(
          LatLng(
            acc.accommodationLatitude,
            acc.accommodationLongitude,
          ),
          style: _styleByCategory(acc.categoryCode),
        );

        // 👇 추가: 마커 탭 이벤트 연결
        if (onMarkerTap != null) {
          poi.onClick = () {
            onMarkerTap(acc);
          };
        }

        _accommodationPois.add(poi);
        successCount++;
      } catch (e) {
        failCount++;
        debugPrint('마커 추가 실패 [${acc.accommodationName}]: $e');
        // 일부 마커 추가 실패해도 계속 진행
      }
    }

    debugPrint('마커 추가 완료: 성공 $successCount개, 실패 $failCount개');
  }

  /* =======================
   * 전체 마커 갱신
   * ======================= */
  Future<void> updateMarkers({
    LatLng? myPosition,
    required List<SearchAccommodationResponseModel> accommodations,
    ValueChanged<SearchAccommodationResponseModel>? onMarkerTap, // 👈 추가
  }) async {
    try {
      await clearAll();

      if (myPosition != null) {
        await addMyLocationMarker(myPosition);
      }

      await addAccommodationMarkers(accommodations, onMarkerTap); // 👈 전달
    } catch (e) {
      debugPrint('마커 업데이트 중 오류: $e');
      rethrow;
    }
  }

  /* =======================
   * 카테고리별 PoiStyle
   * ======================= */
  PoiStyle _styleByCategory(String categoryCode) {
    return PoiStyle(
      icon: KImage.fromAsset(
        'assets/markers/${_markerImageByCategory(categoryCode)}',
        34,
        50,
      ),
    );
  }

  /* =======================
   * 카테고리 → 마커 이미지 매핑
   * ======================= */
  String _markerImageByCategory(String categoryCode) {
    switch (categoryCode) {
      case 'HOTEL':
        return 'hotel.png';
      case 'PENSION':
        return 'pension.png';
      case 'RESORT':
        return 'resort.png';
      case 'MOTEL':
        return 'motel.png';
      case 'GUESTHOUSE':
        return 'guest_house.png';
      case 'GLAMPING':
        return 'glamping.png';
      case 'CAMPNIC':
        return 'campnic.png';
      case 'CARAVAN':
        return 'caravan.png';
      case 'AUTO_CAMPING':
        return 'auto_camping.png';
      case 'CAMPING':
        return 'camping.png';

      case 'ETC':
      default:
        return 'etc.png';
    }
  }

  Future<void> dispose() async {
    await clearAll();
  }
}