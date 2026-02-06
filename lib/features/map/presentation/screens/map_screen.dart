import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:kakao_map_sdk/kakao_map_sdk.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/core/providers/filter_provider.dart';
import 'package:meomulm_frontend/core/utils/date_people_utils.dart';
import 'package:meomulm_frontend/core/widgets/appbar/search_bar_widget.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/providers/accommodation_provider.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/screens/accommodation_filter_screen.dart';
import 'package:meomulm_frontend/features/map/data/datasources/location_service.dart';
import 'package:meomulm_frontend/features/map/presentation/coordinators/map_coordinator.dart';
import 'package:meomulm_frontend/features/map/presentation/providers/map_provider.dart';
import 'package:meomulm_frontend/features/map/presentation/widgets/map_widgets/location_denied_message.dart';
import 'package:meomulm_frontend/features/map/presentation/widgets/map_widgets/my_location_button.dart';
import 'package:meomulm_frontend/features/map/presentation/widgets/map_view_layout.dart';
import 'package:provider/provider.dart';

/// 현재 위치 기반 지도 초기화와 숙소 검색 흐름을 관리하는 스크린
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final LocationService _locationService = LocationService();

  KakaoMapController? _controller;
  LatLng? _myLatLng;
  LocationError? _locationError;
  bool _isMovingToMyLocation = false;
  late MapCoordinator _coordinator;

  @override
  void initState() {
    super.initState();
    _coordinator = MapCoordinator(context.read<MapProvider>());
    _initializeLocation();
  }

  @override
  void dispose() {
    _controller = null;
    _coordinator.dispose();
    super.dispose();
  }

  /// 초기 위치 설정 및 검색
  Future<void> _initializeLocation() async {
    final result = await _locationService.getCurrentPosition();

    if (!mounted) return;

    if (!result.isSuccess) {
      setState(() => _locationError = result.error);
      return;
    }

    final position = result.position!;
    setState(() {
      _myLatLng = LatLng(position.latitude, position.longitude);
      _locationError = null;
    });

    await _searchByPosition(position);
  }

  /// 위치로 숙소 검색 (Coordinator 사용)
  Future<void> _searchByPosition(Position position) async {
    try {
      final filterProvider = context.read<FilterProvider>();

      await _coordinator.searchByPosition(
        latitude: position.latitude,
        longitude: position.longitude,
        filterParams: filterProvider.hasActiveFilters
            ? filterProvider.filterParams
            : null,
      );
    } catch (e) {
      debugPrint('검색 실패: $e');
    }
  }

  /// 내 위치로 이동 및 검색 (중복 방지)
  Future<void> _moveToMyLocationAndSearch() async {
    if (_isMovingToMyLocation) {
      debugPrint('내 위치 이동 중복 호출 차단');
      return;
    }

    _isMovingToMyLocation = true;

    try {
      final result = await _locationService.getCurrentPosition();

      if (!mounted) return;

      if (!result.isSuccess) {
        setState(() => _locationError = result.error);
        return;
      }

      final position = result.position!;
      setState(() {
        _myLatLng = LatLng(position.latitude, position.longitude);
        _locationError = null;
      });

      await _controller?.moveCamera(CameraUpdate.newCenterPosition(_myLatLng!));
      await _searchByPosition(position);
    } finally {
      if (mounted) {
        _isMovingToMyLocation = false;
      }
    }
  }

  /// 현재 위치로 필터 재검색
  Future<void> _reloadWithFilter() async {
    if (_myLatLng == null) return;

    final filterProvider = context.read<FilterProvider>();

    await _coordinator.searchByPosition(
      latitude: _myLatLng!.latitude,
      longitude: _myLatLng!.longitude,
      filterParams: filterProvider.hasActiveFilters
          ? filterProvider.filterParams
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AccommodationProvider>();

    return Scaffold(
      appBar: SearchBarWidget(
        dateText: DatePeopleTextUtil.range(provider.checkIn, provider.checkOut),
        peopleCount: provider.guestNumber,
        onSearch: () => context.push(RoutePaths.mapSearch),
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
      body: Consumer<MapProvider>(
        builder: (context, provider, _) {
          final hasSelectedAccommodation = provider.selectedAccommodation != null;

          return MapViewLayout(
            initialPosition: _myLatLng ?? MapConstants.defaultPosition,
            myPosition: _myLatLng,
            onMapReady: (controller) => _controller = controller,
            additionalOverlays: [
              if (_locationError != null)
                LocationDeniedMessage(
                  errorType: _locationError!,
                  onRetry: _initializeLocation,
                ),
              MyLocationButton(
                onPressed: _moveToMyLocationAndSearch,
                hasSelectedAccommodation: hasSelectedAccommodation,
              ),
            ],
          );
        },
      ),
    );
  }
}