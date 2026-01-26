import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:kakao_map_sdk/kakao_map_sdk.dart';
import 'package:meomulm_frontend/core/constants/paths/route_paths.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/core/utils/date_people_utils.dart';
import 'package:meomulm_frontend/core/widgets/appbar/search_bar_widget.dart';

class MapSearchScreen extends StatefulWidget {
  const MapSearchScreen({super.key});

  @override
  State<MapSearchScreen> createState() => _MapSearchScreenState();
}

class _MapSearchScreenState extends State<MapSearchScreen> {
  KakaoMapController? _controller;
  bool _locationDenied = false;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchBarAppBar(
        dateText: DatePeopleTextUtil.todayToTomorrow(),
        peopleCount: 2,
        onSearch: () => context.push(RoutePaths.searchRegion),
      ),
      body: Stack(
        children: [
          KakaoMap(
            option: const KakaoMapOption(
              position: LatLng(37.5665, 126.9780), // fallback
              zoomLevel: 16,
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

              await controller.labelLayer.addPoi(
                myLatLng,
                style: PoiStyle(), // 기본 마커 OK
              );
            },
          ),

          // 오른쪽 아래 위치 버튼
          SafeArea(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0), // SafeArea 안쪽 여백
                child: FloatingActionButton(
                  heroTag: "myLocationBtn",
                  onPressed: () async {
                    final pos = await _getSafePosition();
                    if (pos == null) return;

                    final myLatLng = LatLng(pos.latitude, pos.longitude);

                    await _controller?.moveCamera(
                      CameraUpdate.newCenterPosition(myLatLng),
                    );
                  },
                  child: const Icon(AppIcons.location),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
