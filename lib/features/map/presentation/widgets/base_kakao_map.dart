import 'package:flutter/material.dart';
import 'package:kakao_map_sdk/kakao_map_sdk.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/features/map/presentation/utils/map_marker_manager.dart';
import 'package:meomulm_frontend/features/accommodation/data/models/search_accommodation_response_model.dart';

/// 카카오 지도를 감싸는 기본 Map 위젯
class BaseKakaoMap extends StatefulWidget {
  final LatLng initialPosition;
  final ValueChanged<KakaoMapController>? onMapReady;

  const BaseKakaoMap({
    super.key,
    required this.initialPosition,
    this.onMapReady,
  });

  @override
  State<BaseKakaoMap> createState() => _BaseKakaoMapState();
}

class _BaseKakaoMapState extends State<BaseKakaoMap> {
  @override
  Widget build(BuildContext context) {
    return KakaoMap(
      option: KakaoMapOption(
        position: widget.initialPosition,
        zoomLevel: MapConstants.defaultZoomLevel,
        mapType: MapType.normal,
      ),
      onMapReady: (controller) {
        widget.onMapReady?.call(controller);
      },
    );
  }
}