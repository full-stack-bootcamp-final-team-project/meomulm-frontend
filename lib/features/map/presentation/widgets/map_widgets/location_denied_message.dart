import 'package:flutter/material.dart';
import 'package:meomulm_frontend/features/map/data/datasources/location_service.dart';

/// 위치 권한 거부/에러 메시지
class LocationDeniedMessage extends StatelessWidget {
  final LocationError errorType;
  final VoidCallback? onRetry;

  const LocationDeniedMessage({
    super.key,
    required this.errorType,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 16,
      left: 16,
      right: 16,
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.orange.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    _getIcon(),
                    color: Colors.orange.shade700,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getTitle(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getMessage(),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // 재시도 버튼 (특정 에러 타입에만 표시)
              if (_canRetry() && onRetry != null) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onRetry,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('다시 시도'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIcon() {
    switch (errorType) {
      case LocationError.serviceDisabled:
        return Icons.location_disabled;
      case LocationError.permissionDenied:
      case LocationError.permissionDeniedForever:
        return Icons.location_off;
      case LocationError.timeout:
        return Icons.hourglass_empty;
      case LocationError.unknown:
        return Icons.error_outline;
    }
  }

  String _getTitle() {
    switch (errorType) {
      case LocationError.serviceDisabled:
        return '위치 서비스가 비활성화되어 있습니다';
      case LocationError.permissionDenied:
        return '위치 권한이 필요합니다';
      case LocationError.permissionDeniedForever:
        return '위치 권한이 거부되었습니다';
      case LocationError.timeout:
        return '위치를 가져올 수 없습니다';
      case LocationError.unknown:
        return '위치 정보 오류';
    }
  }

  String _getMessage() {
    switch (errorType) {
      case LocationError.serviceDisabled:
        return '기기의 위치 서비스를 켜주세요.';
      case LocationError.permissionDenied:
        return '주변 숙소를 찾기 위해 위치 권한이 필요합니다.';
      case LocationError.permissionDeniedForever:
        return '설정에서 위치 권한을 허용해주세요.';
      case LocationError.timeout:
        return '위치 정보를 가져오는데 시간이 초과되었습니다.';
      case LocationError.unknown:
        return '위치 정보를 가져오는데 문제가 발생했습니다.';
    }
  }

  bool _canRetry() {
    // 재시도 가능한 에러 타입
    return errorType == LocationError.permissionDenied ||
        errorType == LocationError.timeout ||
        errorType == LocationError.unknown;
  }
}