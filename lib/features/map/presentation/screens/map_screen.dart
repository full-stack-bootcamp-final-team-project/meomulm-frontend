import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:kakao_map_sdk/kakao_map_sdk.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/core/utils/date_people_utils.dart';
import 'package:meomulm_frontend/core/widgets/appbar/search_bar_widget.dart';
import 'package:meomulm_frontend/features/map/data/datasources/location_service.dart';
import 'package:meomulm_frontend/features/map/presentation/providers/map_provider.dart';
import 'package:meomulm_frontend/features/map/presentation/utils/map_marker_manager.dart';
import 'package:meomulm_frontend/features/map/presentation/widgets/map_widgets/accommodation_counter.dart';
import 'package:meomulm_frontend/features/map/presentation/widgets/map_widgets/error_message.dart';
import 'package:meomulm_frontend/features/map/presentation/widgets/map_widgets/loading_overlay.dart';
import 'package:meomulm_frontend/features/map/presentation/widgets/map_widgets/location_denied_message.dart';
import 'package:meomulm_frontend/features/map/presentation/widgets/map_widgets/my_location_button.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // Services & Managers
  final LocationService _locationService = LocationService();
  MapMarkerManager? _markerManager;

  // State
  KakaoMapController? _controller;
  Position? _currentPosition;
  bool _locationDenied = false;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  // 초기 위치 설정 및 숙소 검색

  Future<void> _initializeLocation() async {
    final position = await _locationService.getCurrentPosition();

    if (!mounted) return;

    if (position == null) {
      setState(() => _locationDenied = true);
      return;
    }

    _currentPosition = position;

    await _searchAccommodationsByPosition(position);

    if (mounted) {
      setState(() {
        _locationDenied = false;
      });
    }
  }

  // 위치 기반 숙소 검색
  Future<void> _searchAccommodationsByPosition(Position position) async {
    if (!mounted) return;

    await context.read<MapProvider>().searchByLocation(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  // 카메라를 특정 위치로 이동
  Future<void> _moveCameraToPosition(Position position) async {
    if (_controller == null) return;

    await _controller!.moveCamera(
      CameraUpdate.newCenterPosition(
        LatLng(position.latitude, position.longitude),
      ),
    );
  }

  // 내 위치로 이동하고 재검색
  Future<void> _moveToMyLocationAndSearch() async {
    final position = await _locationService.getCurrentPosition();
    if (position == null) {
      setState(() => _locationDenied = true);
      return;
    }

    setState(() {
      _currentPosition = position;
      _locationDenied = false;
    });

    await _moveCameraToPosition(position);
    await _searchAccommodationsByPosition(position);
  }

  // 마커 업데이트
  Future<void> _updateMarkers(MapProvider provider) async {
    if (_markerManager == null) return;

    await _markerManager!.updateMarkers(
      myPosition: _currentPosition,
      accommodations: provider.accommodations,
    );
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = context.watch<MapProvider>();

    if (_markerManager != null && !provider.isLoading) {
      _updateMarkers(provider);
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
          return Stack(
            children: [
              _buildKakaoMap(provider),
              if (provider.isLoading) const LoadingOverlay(),
              if (provider.error != null && !provider.isLoading)
                ErrorMessage(message: provider.error!),
              if (!provider.isLoading && provider.accommodations.isNotEmpty)
                AccommodationCounter(count: provider.accommodations.length),
              if (_locationDenied) const LocationDeniedMessage(),
              MyLocationButton(onPressed: _moveToMyLocationAndSearch),
            ],
          );
        },
      ),
    );
  }

  Widget _buildKakaoMap(MapProvider provider) {
    return KakaoMap(
      option: const KakaoMapOption(
        position: MapConstants.defaultPosition,
        zoomLevel: MapConstants.defaultZoomLevel,
        mapType: MapType.normal,
      ),
      onMapReady: (controller) async {
        _controller = controller;
        _markerManager = MapMarkerManager(controller);

        if (_currentPosition != null) {
          await _moveCameraToPosition(_currentPosition!);
        }
      },

    );
  }
}
