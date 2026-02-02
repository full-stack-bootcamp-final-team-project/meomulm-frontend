import 'package:flutter/material.dart';
import 'package:kakao_map_sdk/kakao_map_sdk.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/features/map/presentation/utils/map_marker_manager.dart';
import 'package:meomulm_frontend/features/accommodation/data/models/search_accommodation_response_model.dart';

class BaseKakaoMap extends StatefulWidget {
  final LatLng initialPosition;
  final LatLng? myPosition;
  final List<SearchAccommodationResponseModel> accommodations;
  final ValueChanged<KakaoMapController>? onMapReady;

  const BaseKakaoMap({
    super.key,
    required this.initialPosition,
    required this.accommodations,
    this.myPosition,
    this.onMapReady,
  });

  @override
  State<BaseKakaoMap> createState() => _BaseKakaoMapState();
}

class _BaseKakaoMapState extends State<BaseKakaoMap> {
  MapMarkerManager? _markerManager;

  @override
  void dispose() {
    _markerManager = null;
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant BaseKakaoMap oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_markerManager == null) return;

    final accommodationsChanged =
        oldWidget.accommodations != widget.accommodations;

    final myPositionChanged =
        oldWidget.myPosition != widget.myPosition;

    if (accommodationsChanged || myPositionChanged) {
      _markerManager!.updateMarkers(
        myPosition: widget.myPosition,
        accommodations: widget.accommodations,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return KakaoMap(
      option: KakaoMapOption(
        position: widget.initialPosition,
        zoomLevel: MapConstants.defaultZoomLevel,
        mapType: MapType.normal,
      ),
      onMapReady: (controller) {
        _markerManager = MapMarkerManager(controller);

        // 최초 마커 세팅
        _markerManager!.updateMarkers(
          myPosition: widget.myPosition,
          accommodations: widget.accommodations,
        );

        widget.onMapReady?.call(controller);
      },
    );
  }
}