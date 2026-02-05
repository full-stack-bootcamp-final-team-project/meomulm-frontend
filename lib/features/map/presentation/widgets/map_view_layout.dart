import 'package:flutter/material.dart';
import 'package:kakao_map_sdk/kakao_map_sdk.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/features/map/presentation/controllers/map_marker_controller.dart';
import 'package:meomulm_frontend/features/map/presentation/providers/map_provider.dart';
import 'package:meomulm_frontend/features/map/presentation/widgets/base_kakao_map.dart';
import 'package:meomulm_frontend/features/map/presentation/widgets/accommodation_counter.dart';
import 'package:meomulm_frontend/features/map/presentation/widgets/error_message.dart';
import 'package:meomulm_frontend/features/map/presentation/widgets/loading_overlay.dart';
import 'package:meomulm_frontend/features/map/presentation/widgets/map_accommodation_card.dart';
import 'package:provider/provider.dart';

/// 지도 뷰 공통 레이아웃
class MapViewLayout extends StatefulWidget {
  final LatLng initialPosition;
  final LatLng? myPosition;
  final void Function(KakaoMapController)? onMapReady;
  final List<Widget> additionalOverlays;

  const MapViewLayout({
    super.key,
    required this.initialPosition,
    this.myPosition,
    this.onMapReady,
    this.additionalOverlays = const [],
  });

  @override
  State<MapViewLayout> createState() => _MapViewLayoutState();
}

class _MapViewLayoutState extends State<MapViewLayout> {
  MapMarkerController? _markerController;

  @override
  void dispose() {
    _markerController?.dispose();
    super.dispose();
  }

  /// 지도 준비 완료 시 마커 컨트롤러 초기화 및 콜백 호출
  void _onMapReady(KakaoMapController controller) {
    _markerController = MapMarkerController(controller);

    // 초기 마커 설정
    _updateMarkers();

    // 외부 콜백 호출
    widget.onMapReady?.call(controller);
  }

  /// 마커 업데이트
  void _updateMarkers() {
    if (_markerController == null) return;

    final provider = context.read<MapProvider>();

    _markerController!.update(
      myPosition: widget.myPosition,
      accommodations: provider.accommodations,
      onMarkerTap: (accommodation) {
        provider.selectAccommodation(accommodation);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MapProvider>(
      builder: (context, provider, _) {
        // Provider 상태 변경 시 마커 업데이트
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _updateMarkers();
        });

        final hasSelectedAccommodation = provider.selectedAccommodation != null;

        return Stack(
          children: [
            // ===== 지도 (순수 렌더링만 담당) =====
            BaseKakaoMap(
              initialPosition: widget.initialPosition,
              onMapReady: _onMapReady,
            ),

            // ===== 로딩 오버레이 =====
            if (provider.isLoading) const LoadingOverlay(),

            // ===== 에러 메시지 =====
            if (provider.error != null && !provider.isLoading)
              ErrorMessage(
                message: provider.error!.message,
                onRetry: () => provider.retry(),
              ),

            // ===== 숙소 개수 카운터 =====
            if (!provider.isLoading && provider.accommodations.isNotEmpty)
              AccommodationCounter(count: provider.accommodations.length),

            // ===== 추가 오버레이 (내 위치 버튼, 권한 메시지 등) =====
            ...widget.additionalOverlays,

            // ===== 선택된 숙소 카드 =====
            if (hasSelectedAccommodation)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: MapAccommodationCard(
                      accommodation: provider.selectedAccommodation!,
                      onClose: () => provider.selectAccommodation(null),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}