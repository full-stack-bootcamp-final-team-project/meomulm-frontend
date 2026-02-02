import 'package:geolocator/geolocator.dart';

class LocationService {
  // 위치 가져오기 타임아웃 설정
  static const Duration _timeoutDuration = Duration(seconds: 10);

  /// 위치 권한 상태 확인
  Future<LocationPermission> checkPermission() {
    return Geolocator.checkPermission();
  }

  /// 권한 요청
  Future<LocationPermission> requestPermission() {
    return Geolocator.requestPermission();
  }

  /// 위치 서비스 활성화 여부 확인
  Future<bool> isLocationServiceEnabled() {
    return Geolocator.isLocationServiceEnabled();
  }

  Future<Position?> getCurrentPosition() async {
    final serviceEnabled = await isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

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
        timeLimit: _timeoutDuration,
      );
    } catch (e) {
      try {
        return await Geolocator.getLastKnownPosition();
      } catch (_) {
        return null;
      }
    }
  }

  Stream<Position> getPositionStream({
    LocationAccuracy accuracy = LocationAccuracy.high,
    int distanceFilter = 10,
  }) {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: accuracy,
        distanceFilter: distanceFilter,
      ),
    );
  }
}