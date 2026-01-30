import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:kakao_map_sdk/kakao_map_sdk.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/core/utils/date_people_utils.dart';
import 'package:meomulm_frontend/core/widgets/appbar/search_bar_widget.dart';
import 'package:meomulm_frontend/features/accommodation/data/models/accommodation_model.dart';
import 'package:meomulm_frontend/features/map/presentation/providers/map_provider.dart';
import 'package:meomulm_frontend/features/map/presentation/widgets/map_widgets/accommodation_counter.dart';
import 'package:meomulm_frontend/features/map/presentation/widgets/map_widgets/error_message.dart';
import 'package:meomulm_frontend/features/map/presentation/widgets/map_widgets/location_denied_message.dart';
import 'package:meomulm_frontend/features/map/presentation/widgets/map_widgets/my_location_button.dart';
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
  final List<Poi> _accommodationPois = [];
  Poi? _myLocationPoi;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    final pos = await _getSafePosition();
    if (pos == null) return;

    setState(() => _currentPosition = pos);
    await _searchAccommodationsByPosition(pos);
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

  Future<void> _searchAccommodationsByPosition(Position position) async {
    if (!mounted) return;

    await context.read<MapProvider>().searchByLocation(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  Future<void> _clearAllMarkers() async {
    // 숙소 마커 제거
    for (final poi in _accommodationPois) {
      await poi.remove();
    }
    _accommodationPois.clear();

    // 내 위치 마커 제거
    await _myLocationPoi?.remove();
    _myLocationPoi = null;
  }

  Future<void> _addMyLocationMarker() async {
    if (_controller == null || _currentPosition == null) return;

    _myLocationPoi = await _controller!.labelLayer.addPoi(
      LatLng(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      ),
      style: PoiStyle(),
    );
  }

  Future<void> _addAccommodationMarkers(List<Accommodation> accommodations) async {
    if (_controller == null) return;

    await _clearAllMarkers();
    await _addMyLocationMarker();

    // 숙소 마커 추가
    for (final acc in accommodations) {
      if (acc.accommodationLatitude == null ||
          acc.accommodationLongitude == null) continue;

      final poi = await _controller!.labelLayer.addPoi(
        LatLng(
          acc.accommodationLatitude!,
          acc.accommodationLongitude!,
        ),
        style: PoiStyle(),
      );

      _accommodationPois.add(poi);
    }
  }

  Future<void> _moveToMyLocation() async {
    final pos = await _getSafePosition();
    if (pos == null) return;

    final myLatLng = LatLng(pos.latitude, pos.longitude);

    await _controller?.moveCamera(
      CameraUpdate.newCenterPosition(myLatLng),
    );

    await _searchAccommodationsByPosition(pos);
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
              _buildKakaoMap(provider),
              if (provider.isLoading) _buildLoadingIndicator(),
              if (provider.error != null && !provider.isLoading)
                ErrorMessage(message: provider.error!),
              if (!provider.isLoading && provider.accommodations.isNotEmpty)
                AccommodationCounter(count: provider.accommodations.length),
              if (_locationDenied) const LocationDeniedMessage(),
              MyLocationButton(onPressed: _moveToMyLocation),
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
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      color: Colors.black.withOpacity(0.3),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
