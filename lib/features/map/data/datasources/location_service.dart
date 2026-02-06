import 'dart:async';

import 'package:geolocator/geolocator.dart';

/// 위치 조회 결과
class LocationResult {
  final Position? position;
  final LocationError? error;

  LocationResult.success(this.position) : error = null;
  LocationResult.failure(this.error) : position = null;

  bool get isSuccess => position != null;
  bool get hasError => error != null;
}

/// 위치 에러 타입
enum LocationError {
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
  timeout,
  unknown,
}

/// 위치 서비스 및 권한을 관리하고 현재 위치 조회/실시간 위치 추적 기능을 제공하는 유틸 서비스
class LocationService {
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

  /// 현재 위치 가져오기 (Result 패턴)
  Future<LocationResult> getCurrentPosition() async {
    // 1. 위치 서비스 활성화 확인
    final serviceEnabled = await isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationResult.failure(LocationError.serviceDisabled);
    }

    // 2. 권한 확인 및 요청
    var permission = await checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      return LocationResult.failure(LocationError.permissionDeniedForever);
    }

    if (permission == LocationPermission.denied) {
      return LocationResult.failure(LocationError.permissionDenied);
    }

    // 3. 위치 조회
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: _timeoutDuration,
      );
      return LocationResult.success(position);
    } on TimeoutException {
      // 타임아웃 시 마지막 알려진 위치 시도
      try {
        final lastPosition = await Geolocator.getLastKnownPosition();
        if (lastPosition != null) {
          return LocationResult.success(lastPosition);
        }
        return LocationResult.failure(LocationError.timeout);
      } catch (_) {
        return LocationResult.failure(LocationError.timeout);
      }
    } catch (e) {
      // 기타 에러 시 마지막 알려진 위치 시도
      try {
        final lastPosition = await Geolocator.getLastKnownPosition();
        if (lastPosition != null) {
          return LocationResult.success(lastPosition);
        }
        return LocationResult.failure(LocationError.unknown);
      } catch (_) {
        return LocationResult.failure(LocationError.unknown);
      }
    }
  }

  /// 위치 스트림 (실시간 위치 추적)
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