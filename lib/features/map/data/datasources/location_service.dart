import 'package:geolocator/geolocator.dart';

class LocationService {
  // 위치 권한 상태 확인 및 요청
  Future<LocationPermission> checkPermission() {
    return Geolocator.checkPermission();
  }

  /// 권한 요청
  Future<LocationPermission> requestPermission() {
    return Geolocator.requestPermission();
  }

  /// 현재 위치 가져오기 (필요 시에만 권한 요청)
  Future<Position?> getCurrentPosition() async {
    var permission = await checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (_) {
      return null;
    }
  }
}

