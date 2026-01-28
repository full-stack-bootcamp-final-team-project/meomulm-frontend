// map_search_result_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kakao_map_sdk/kakao_map_sdk.dart';
import 'package:meomulm_frontend/core/constants/paths/route_paths.dart';
import 'package:meomulm_frontend/core/utils/date_people_utils.dart';
import 'package:meomulm_frontend/core/widgets/appbar/search_bar_widget.dart';
import 'package:meomulm_frontend/features/map/data/models/accommodation.dart';
import 'package:meomulm_frontend/features/map/presentation/providers/map_provider.dart';
import 'package:meomulm_frontend/features/map/presentation/widgets/map_search_result_widgets/map_search_result_card.dart';
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
  LatLng? _regionCenter;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeSearch();
  }

  Future<void> _initializeSearch() async {
    // 지역명으로 좌표 가져오기
    _regionCenter = await _getRegionCoordinates(widget.region);

    if (!mounted || _regionCenter == null) return;

    // 해당 지역 좌표로 숙소 검색
    await context.read<MapProvider>().searchByLocation(
      latitude: _regionCenter!.latitude,
      longitude: _regionCenter!.longitude,
    );

    setState(() => _isInitialized = true);
  }

  Future<LatLng?> _getRegionCoordinates(String region) async {
    // TODO: 지역명 -> 좌표 변환 로직
    // 1. 백엔드에 지역명으로 좌표 요청 API가 있다면 사용
    // 2. 또는 카카오 Geocoding API 사용
    // 3. 임시로 하드코딩 (예시)

    final regionCoordinates = {
      '서울': const LatLng(37.5665, 126.9780),
      '부산': const LatLng(35.1796, 129.0756),
      '제주': const LatLng(33.4996, 126.5312),
      // ... 다른 지역들
    };

    // 지역명에서 키워드 추출 (예: "서울특별시 강남구" -> "서울")
    for (var key in regionCoordinates.keys) {
      if (region.contains(key)) {
        return regionCoordinates[key];
      }
    }

    // 기본값 (서울)
    return const LatLng(37.5665, 126.9780);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchBarWidget(
        keyword: widget.region,
        dateText: DatePeopleTextUtil.todayToTomorrow(),
        peopleCount: widget.guestCount,
        onClear: () => context.push(RoutePaths.map),
      ),
      body: Consumer<MapProvider>(
        builder: (context, provider, child) {
          return Stack(
            children: [
              KakaoMap(
                option: KakaoMapOption(
                  position: _regionCenter ?? const LatLng(37.5665, 126.9780),
                  zoomLevel: 14,
                  mapType: MapType.normal,
                ),
                onMapReady: (controller) async {
                  _controller = controller;

                  if (_isInitialized) {
                    _addAccommodationMarkers(provider.accommodations);
                  }
                },
              ),

              // 로딩
              if (provider.isLoading)
                const Center(child: CircularProgressIndicator()),

              // 에러
              if (provider.error != null)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(provider.error!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _initializeSearch,
                        child: const Text('다시 시도'),
                      ),
                    ],
                  ),
                ),

              // 숙소 개수
              if (!provider.isLoading && provider.accommodations.isNotEmpty)
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Text(
                      '${widget.region} 반경 5km 내 ${provider.accommodations.length}개 숙소',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

              // 하단 숙소 리스트
              if (provider.accommodations.isNotEmpty)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _buildAccommodationList(provider.accommodations),
                ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _addAccommodationMarkers(
    List<Accommodation> accommodations,
  ) async {
    if (_controller == null) return;

    for (var acc in accommodations) {
      await _controller!.labelLayer.addPoi(
        LatLng(acc.accommodationLatitude, acc.accommodationLongitude),
        style: PoiStyle(
          // 숙소 마커 스타일
        ),
      );
    }
  }

  Widget _buildAccommodationList(List<Accommodation> accommodations) {
    return Container(
      height: 180,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: accommodations.length,
        itemBuilder: (context, index) {
          final acc = accommodations[index];
          return MapSearchResultCard(
            accommodation: acc,
            onTap: () async {
              await _controller?.moveCamera(
                CameraUpdate.newCenterPosition(
                  LatLng(acc.accommodationLatitude, acc.accommodationLongitude),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
