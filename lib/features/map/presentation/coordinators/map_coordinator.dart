import 'package:flutter/material.dart';
import 'package:kakao_map_sdk/kakao_map_sdk.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/features/map/presentation/providers/map_provider.dart';

/// 지도 검색 흐름을 조정하고 위치/지역 기반 숙소 검색을 위임하는 코디네이터
class MapCoordinator {
  final MapProvider provider;

  MapCoordinator(this.provider);

  LatLng getRegionCenter(String region) {
    return RegionCoordinates.getCoordinates(region) ??
        MapConstants.defaultPosition;
  }

  /// 위치 기반 검색 (필터 포함)
  Future<void> searchByPosition({
    required double latitude,
    required double longitude,
    Map<String, dynamic>? filterParams,
  }) async {
    try {
      await provider.searchByLocation(
        latitude: latitude,
        longitude: longitude,
        filterParams: filterParams,
      );
    } catch (e) {
      debugPrint('MapCoordinator: 검색 실패 - $e');
      rethrow;
    }
  }

  /// 지역명으로 검색 (filterParams 지원)
  Future<void> searchByRegion(
      String region, {
        Map<String, dynamic>? filterParams,
      }) async {
    final center = getRegionCenter(region);

    await searchByPosition(
      latitude: center.latitude,
      longitude: center.longitude,
      filterParams: filterParams,
    );
  }

  void dispose() {
    provider.clear();
  }
}