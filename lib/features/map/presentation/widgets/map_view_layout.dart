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

/// 지도 화면에서 공통으로 사용하는 메인 레이아웃 위젯
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
  bool _isUpdatingMarkers = false;

  @override
  void dispose() {
    _markerController?.dispose();
    super.dispose();
  }

  /// 지도 준비 완료 시 마커 컨트롤러 초기화 및 콜백 호출
  void _onMapReady(KakaoMapController controller) {
    _markerController?.dispose();
    _markerController = MapMarkerController(controller);
    _updateMarkers();
    widget.onMapReady?.call(controller);
  }


  /// 마커 업데이트
  Future<void> _updateMarkers() async {
    if (_markerController == null || _isUpdatingMarkers) return;

    _isUpdatingMarkers = true;
    try {
      final provider = context.read<MapProvider>();
      await _markerController!.update(
        myPosition: widget.myPosition,
        accommodations: provider.accommodations,
        onMarkerTap: (accommodation) {
          provider.selectAccommodation(accommodation);
        },
      );
    } catch (e) {
      debugPrint('마커 업데이트 실패: $e');
    } finally {
      _isUpdatingMarkers = false;
    }
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
            // ===== 지도 =====
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

            // ===== 숙소 개수 =====
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