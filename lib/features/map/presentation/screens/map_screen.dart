import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:kakao_map_sdk/kakao_map_sdk.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/core/utils/date_people_utils.dart';
import 'package:meomulm_frontend/core/widgets/appbar/search_bar_widget.dart';
import 'package:meomulm_frontend/features/map/data/datasources/location_service.dart';
import 'package:meomulm_frontend/features/map/presentation/providers/map_provider.dart';
import 'package:meomulm_frontend/features/map/presentation/widgets/base_kakao_map.dart';
import 'package:meomulm_frontend/features/map/presentation/widgets/accommodation_counter.dart';
import 'package:meomulm_frontend/features/map/presentation/widgets/map_accommodation_card.dart';
import 'package:meomulm_frontend/features/map/presentation/widgets/error_message.dart';
import 'package:meomulm_frontend/features/map/presentation/widgets/loading_overlay.dart';
import 'package:meomulm_frontend/features/map/presentation/widgets/map_widgets/location_denied_message.dart';
import 'package:meomulm_frontend/features/map/presentation/widgets/map_widgets/my_location_button.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final LocationService _locationService = LocationService();

  KakaoMapController? _controller;
  LatLng? _myLatLng;
  Position? _lastSearchPosition;
  bool _locationDenied = false;

  static const double _minSearchDistance = 50.0;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  @override
  void dispose() {
    _controller = null;
    super.dispose();
  }

  Future<void> _initializeLocation() async {
    final position = await _locationService.getCurrentPosition();

    if (!mounted) return;

    if (position == null) {
      setState(() => _locationDenied = true);
      return;
    }

    setState(() {
      _myLatLng = LatLng(position.latitude, position.longitude);
      _locationDenied = false;
    });

    await _searchByPosition(position);
  }

  Future<void> _searchByPosition(Position position) async {
    if (_shouldSkipSearch(position)) return;

    try {
      await context.read<MapProvider>().searchByLocation(
        latitude: position.latitude,
        longitude: position.longitude,
      );
      _lastSearchPosition = position;
    } catch (e) {
      debugPrint('검색 실패: $e');
    }
  }

  bool _shouldSkipSearch(Position position) {
    if (_lastSearchPosition == null) return false;

    final distance = Geolocator.distanceBetween(
      _lastSearchPosition!.latitude,
      _lastSearchPosition!.longitude,
      position.latitude,
      position.longitude,
    );

    return distance < _minSearchDistance;
  }

  Future<void> _moveToMyLocationAndSearch() async {
    final position = await _locationService.getCurrentPosition();

    if (position == null) {
      setState(() => _locationDenied = true);
      return;
    }

    setState(() {
      _myLatLng = LatLng(position.latitude, position.longitude);
      _locationDenied = false;
    });

    await _controller?.moveCamera(CameraUpdate.newCenterPosition(_myLatLng!));

    await _searchByPosition(position);
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
        builder: (context, provider, _) {
          return Stack(
            children: [
              BaseKakaoMap(
                initialPosition: _myLatLng ?? MapConstants.defaultPosition,
                myPosition: _myLatLng,
                accommodations: provider.accommodations,
                onMapReady: (controller) => _controller = controller,
                // 마커 클릭 시 선택된 숙소 설정
                onMarkerTap: (accommodation) {
                  provider.selectAccommodation(accommodation);
                },
              ),
              if (provider.isLoading) const LoadingOverlay(),
              if (provider.error != null && !provider.isLoading)
                ErrorMessage(message: provider.error!),
              if (!provider.isLoading && provider.accommodations.isNotEmpty)
                AccommodationCounter(count: provider.accommodations.length),
              if (_locationDenied) const LocationDeniedMessage(),

              // 선택된 숙소가 있을 때만 카드 표시
              if (provider.selectedAccommodation != null)
                SafeArea(
                  child: MapAccommodationCard(
                    accommodation: provider.selectedAccommodation!,
                    onTap: () {
                      // 카드 클릭 시 해당 위치로 이동
                      _controller?.moveCamera(
                        CameraUpdate.newCenterPosition(
                          LatLng(
                            provider
                                .selectedAccommodation!
                                .accommodationLatitude,
                            provider
                                .selectedAccommodation!
                                .accommodationLongitude,
                          ),
                        ),
                      );
                    },
                    onClose: () => provider.selectAccommodation(null),
                  ),
                ),
              MyLocationButton(onPressed: _moveToMyLocationAndSearch),
            ],
          );
        },
      ),
    );
  }
}
