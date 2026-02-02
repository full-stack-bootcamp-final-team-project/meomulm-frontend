import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kakao_map_sdk/kakao_map_sdk.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/core/utils/date_people_utils.dart';
import 'package:meomulm_frontend/core/widgets/appbar/search_bar_widget.dart';
import 'package:meomulm_frontend/features/map/presentation/providers/map_provider.dart';
import 'package:meomulm_frontend/features/map/presentation/widgets/base_kakao_map.dart';
import 'package:meomulm_frontend/features/map/presentation/widgets/accommodation_counter.dart';
import 'package:meomulm_frontend/features/map/presentation/widgets/map_widgets/error_message.dart';
import 'package:meomulm_frontend/features/map/presentation/widgets/loading_overlay.dart';
import 'package:meomulm_frontend/features/map/presentation/widgets/map_search_result_widgets/accommodation_list.dart';
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
  State<MapSearchResultScreen> createState() =>
      _MapSearchResultScreenState();
}

class _MapSearchResultScreenState extends State<MapSearchResultScreen> {
  KakaoMapController? _controller;
  LatLng? _regionCenter;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void dispose() {
    _controller = null;
    super.dispose();
  }

  Future<void> _initialize() async {
    _regionCenter = RegionCoordinates.getCoordinates(widget.region);

    _regionCenter ??= MapConstants.defaultPosition;

    if (!mounted) return;

    try {
      await context.read<MapProvider>().searchByLocation(
        latitude: _regionCenter!.latitude,
        longitude: _regionCenter!.longitude,
      );
    } catch (e) {
      debugPrint('숙소 검색 실패: $e');
    }
  }

  Future<void> _moveCameraToAccommodation(
      double lat, double lng) async {
    if (_controller == null) return;

    await _controller!.moveCamera(
      CameraUpdate.newCenterPosition(LatLng(lat, lng)),
    );
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
        builder: (context, provider, _) {
          return Stack(
            children: [
              BaseKakaoMap(
                initialPosition:
                _regionCenter ?? MapConstants.defaultPosition,
                accommodations: provider.accommodations,
                onMapReady: (controller) => _controller = controller,
              ),
              if (provider.isLoading) const LoadingOverlay(),
              if (provider.error != null && !provider.isLoading)
                ErrorMessage(message: provider.error!),
              if (!provider.isLoading &&
                  provider.accommodations.isNotEmpty)
                AccommodationCounter(
                    count: provider.accommodations.length),
              if (provider.accommodations.isNotEmpty)
                AccommodationList(
                  accommodations: provider.accommodations,
                  onAccommodationTap:
                  _moveCameraToAccommodation,
                ),
            ],
          );
        },
      ),
    );
  }
}