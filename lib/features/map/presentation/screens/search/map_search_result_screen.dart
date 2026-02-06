import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kakao_map_sdk/kakao_map_sdk.dart';
import 'package:meomulm_frontend/core/constants/paths/route_paths.dart';
import 'package:meomulm_frontend/core/providers/filter_provider.dart';
import 'package:meomulm_frontend/core/utils/date_people_utils.dart';
import 'package:meomulm_frontend/core/widgets/appbar/search_bar_widget.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/providers/accommodation_provider.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/screens/accommodation_filter_screen.dart';
import 'package:meomulm_frontend/features/map/presentation/coordinators/map_coordinator.dart';
import 'package:meomulm_frontend/features/map/presentation/providers/map_provider.dart';
import 'package:meomulm_frontend/features/map/presentation/widgets/map_view_layout.dart';
import 'package:provider/provider.dart';

/// 지역 기반 숙소 검색 결과를 지도에 표시하고 검색 흐름을 관리하는 스크린
class MapSearchResultScreen extends StatefulWidget {
  final String region;

  const MapSearchResultScreen({
    super.key,
    required this.region,
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
    _regionCenter = _coordinator.getRegionCenter(widget.region);
    _searchByRegion();
  }

  @override
  void dispose() {
    _controller = null;
    _coordinator.dispose();
    super.dispose();
  }

  /// region 좌표로 검색 (필터 포함)
  Future<void> _searchByRegion() async {
    try {
      final filterProvider = context.read<FilterProvider>();

      await _coordinator.searchByRegion(
        widget.region,
        filterParams: filterProvider.hasActiveFilters
            ? filterProvider.filterParams
            : null,
      );
    } catch (e) {
      debugPrint('검색 실패: $e');
    }
  }
  /// 필터 재적용
  Future<void> _reloadWithFilter() async {
    await _searchByRegion();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AccommodationProvider>();

    return Scaffold(
      appBar: SearchBarWidget(
        keyword: widget.region,
        dateText: DatePeopleTextUtil.range(provider.checkIn, provider.checkOut),
        peopleCount: provider.guestNumber,
        onClear: () => context.pop(),
        onBack: ()=> context.go(RoutePaths.home),
        onFilter: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AccommodationFilterScreen(),
            ),
          );

          if (result == true) {
            _reloadWithFilter();
          }
        },
      ),
      body: MapViewLayout(
        initialPosition: _regionCenter,
        onMapReady: (controller) => _controller = controller,
        additionalOverlays: const [],
      ),
    );
  }
}