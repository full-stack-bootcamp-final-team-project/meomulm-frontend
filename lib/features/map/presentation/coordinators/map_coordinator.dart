import 'package:flutter/material.dart';
import 'package:kakao_map_sdk/kakao_map_sdk.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/features/map/presentation/providers/map_provider.dart';

/// 지도 초기화 및 검색을 조정하는 클래스
class MapCoordinator {
  final MapProvider provider;

  MapCoordinator(this.provider);

  /// 지역 중심 좌표 가져오기 (동기)
  LatLng getRegionCenter(String region) {
    return RegionCoordinates.getCoordinates(region) ?? MapConstants.defaultPosition;
  }

  /// 위치 기반 검색 (비동기)
  /// filterParams가 있으면 /search, 없으면 /map 엔드포인트 호출
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

  /// 지역명으로 검색 (편의 메서드)
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

  /// 정리
  void dispose() {
    provider.clear();
  }
}