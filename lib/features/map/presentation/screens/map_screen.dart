import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:kakao_map_sdk/kakao_map_sdk.dart';
import 'package:meomulm_frontend/core/constants/paths/route_paths.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/core/utils/date_people_utils.dart';
import 'package:meomulm_frontend/core/widgets/appbar/search_bar_widget.dart';
import 'package:meomulm_frontend/features/map/data/models/accommodation.dart';
import 'package:meomulm_frontend/features/map/presentation/providers/map_provider.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  KakaoMapController? _controller;
  bool _locationDenied = false;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    final pos = await _getSafePosition();
    if (pos == null) return;

    setState(() => _currentPosition = pos);

    // 현재 위치로 숙소 검색
    if (mounted) {
      await context.read<MapProvider>().searchByLocation(
        latitude: pos.latitude,
        longitude: pos.longitude,
      );
    }
  }

  Future<Position?> _getSafePosition() async {
    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      setState(() => _locationDenied = true);
      return null;
    }

    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> _addAccommodationMarkers(List<Accommodation> accommodations) async {
    if (_controller == null) return;

    // 기존 마커 제거 (옵션)
    // await _controller!.labelLayer.clear();

    // 내 위치 마커 추가
    if (_currentPosition != null) {
      await _controller!.labelLayer.addPoi(
        LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        style: PoiStyle(
          // 내 위치 스타일 (파란색 점)
        ),
      );
    }

    // 숙소 마커 추가
    for (var acc in accommodations) {
      await _controller!.labelLayer.addPoi(
        LatLng(acc.accommodationLatitude, acc.accommodationLongitude),
        style: PoiStyle(
          // 숙소 마커 스타일 (빨간색 핀 등)
        ),
        // 마커 클릭 이벤트 (선택사항)
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchBarWidget(
        dateText: DatePeopleTextUtil.todayToTomorrow(),
        peopleCount: 2,
        onSearch: () => context.push(RoutePaths.mapSearch),
      ),
      body: Consumer<MapProvider>(
        builder: (context, provider, child) {
          // 숙소 데이터가 로드되면 마커 추가
          if (_controller != null && !provider.isLoading) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _addAccommodationMarkers(provider.accommodations);
            });
          }

          return Stack(
            children: [
              KakaoMap(
                option: const KakaoMapOption(
                  position: LatLng(37.5665, 126.9780), // fallback
                  zoomLevel: 14,
                  mapType: MapType.normal,
                ),
                onMapReady: (controller) async {
                  _controller = controller;

                  final pos = await _getSafePosition();
                  if (pos == null) return;

                  final myLatLng = LatLng(pos.latitude, pos.longitude);

                  await controller.moveCamera(
                    CameraUpdate.newCenterPosition(myLatLng),
                  );

                  // 숙소가 이미 로드된 경우 마커 추가
                  if (provider.accommodations.isNotEmpty) {
                    await _addAccommodationMarkers(provider.accommodations);
                  }
                },
              ),

              // 로딩 인디케이터
              if (provider.isLoading)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),

              // 에러 메시지
              if (provider.error != null && !provider.isLoading)
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red.shade700),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              provider.error!,
                              style: TextStyle(color: Colors.red.shade700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // 숙소 개수 표시
              if (!provider.isLoading && provider.accommodations.isNotEmpty)
                Positioned(
                  top: 16,
                  left: 16,
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.home_outlined,
                            size: 18,
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '반경 5km 내 ${provider.accommodations.length}개 숙소',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // 위치 권한 거부 안내
              if (_locationDenied)
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.location_off,
                                  color: Colors.orange.shade700),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '위치 권한이 필요합니다',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '설정에서 위치 권한을 허용해주세요',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // 오른쪽 아래 위치 버튼
              SafeArea(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 현재 위치로 이동 버튼
                        FloatingActionButton(
                          heroTag: "myLocationBtn",
                          backgroundColor: Colors.white,
                          onPressed: () async {
                            final pos = await _getSafePosition();
                            if (pos == null) return;

                            final myLatLng = LatLng(pos.latitude, pos.longitude);

                            await _controller?.moveCamera(
                              CameraUpdate.newCenterPosition(myLatLng),
                            );

                            // 현재 위치 기준으로 재검색
                            if (mounted) {
                              await context.read<MapProvider>().searchByLocation(
                                latitude: pos.latitude,
                                longitude: pos.longitude,
                              );
                            }
                          },
                          child: const Icon(
                            AppIcons.location,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // 하단 숙소 리스트 (선택사항)
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

  Widget _buildAccommodationList(List<Accommodation> accommodations) {
    return Container(
      height: 180,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(16),
        itemCount: accommodations.length,
        itemBuilder: (context, index) {
          final acc = accommodations[index];
          return _AccommodationCard(
            accommodation: acc,
            onTap: () async {
              // 해당 숙소로 지도 이동
              await _controller?.moveCamera(
                CameraUpdate.newCenterPosition(
                  LatLng(
                    acc.accommodationLatitude,
                    acc.accommodationLongitude,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// 숙소 카드 위젯
class _AccommodationCard extends StatelessWidget {
  final Accommodation accommodation;
  final VoidCallback onTap;

  const _AccommodationCard({
    required this.accommodation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            // 이미지
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: Image.network(
                accommodation.mainImageUrl,
                width: 100,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 100,
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),

            // 정보
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      accommodation.accommodationName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      accommodation.accommodationAddress,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          '${_formatPrice(accommodation.minPrice)}원',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blue,
                          ),
                        ),
                        Text(
                          ' ~',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPrice(int price) {
    if (price >= 10000) {
      final man = price ~/ 10000;
      final remainder = price % 10000;
      if (remainder == 0) {
        return '$man만';
      }
      return '$man만 ${(remainder / 1000).toStringAsFixed(0)}천';
    }
    return price.toString();
  }
}