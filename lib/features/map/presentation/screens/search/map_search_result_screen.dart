import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kakao_map_sdk/kakao_map_sdk.dart';
import 'package:meomulm_frontend/core/utils/date_people_utils.dart';
import 'package:meomulm_frontend/core/widgets/appbar/search_bar_widget.dart';
import 'package:meomulm_frontend/features/map/presentation/coordinators/map_coordinator.dart';
import 'package:meomulm_frontend/features/map/presentation/providers/map_provider.dart';
import 'package:meomulm_frontend/features/map/presentation/widgets/map_view_layout.dart';
import 'package:provider/provider.dart';

class MapSearchResultScreen extends StatefulWidget {
  final String region;
  final DateTimeRange dateRange;
  final int guestCount;

  const MapSearchResultScreen({
    super.key,
    required this.region,
    required this.dateRange,
    required this.guestCount,
  });

  @override
  State<MapSearchResultScreen> createState() => _MapSearchResultScreenState();
}

class _MapSearchResultScreenState extends State<MapSearchResultScreen> {
  KakaoMapController? _controller;
  late LatLng _regionCenter;
  late MapCoordinator _coordinator;

  @override
  void initState() {
    super.initState();
    _coordinator = MapCoordinator(context.read<MapProvider>());

    // ✅ 1. 좌표는 동기적으로 즉시 가져오기
    _regionCenter = _coordinator.getRegionCenter(widget.region);

    // ✅ 2. 검색은 비동기적으로 백그라운드 실행
    _coordinator.searchByRegion(widget.region);
  }

  @override
  void dispose() {
    _controller = null;
    _coordinator.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchBarWidget(
        keyword: widget.region,
        dateText: DatePeopleTextUtil.todayToTomorrow(),
        peopleCount: widget.guestCount,
        onClear: () => context.pop(),
      ),
      body: MapViewLayout(
        // ✅ 즉시 올바른 지역 중심으로 렌더링
        initialPosition: _regionCenter,
        onMapReady: (controller) => _controller = controller,
        additionalOverlays: const [],
      ),
      // ✅ 로딩은 MapViewLayout 내부의 LoadingOverlay가 처리
    );
  }
}