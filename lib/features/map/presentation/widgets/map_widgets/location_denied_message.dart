import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/core/widgets/buttons/button_widgets.dart';
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
      top: AppSpacing.lg,
      left: AppSpacing.lg,
      right: AppSpacing.lg,
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(AppBorderRadius.sm),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.gray3,
            borderRadius: BorderRadius.circular(AppBorderRadius.sm),
            border: Border.all(color: AppColors.gray3),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(_getIcon(), color: AppColors.sub, size: AppIcons.sizeLg),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_getTitle(), style: AppTextStyles.dialogLg),
                        const SizedBox(height: AppSpacing.xs),
                        Text(_getMessage(), style: AppTextStyles.bodyMd),
                      ],
                    ),
                  ),
                ],
              ),

              // 재시도 버튼 (특정 에러 타입에만 표시)
              if (_canRetry() && onRetry != null) ...[
                const SizedBox(height: AppSpacing.md),
                LargeButton(label: LocationMessages.retryButton, onPressed: onRetry!, enabled: true),
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
        return LocationMessages.serviceDisabledTitle;
      case LocationError.permissionDenied:
        return LocationMessages.permissionDeniedTitle;
      case LocationError.permissionDeniedForever:
        return LocationMessages.permissionDeniedForeverTitle;
      case LocationError.timeout:
        return LocationMessages.timeoutTitle;
      case LocationError.unknown:
        return LocationMessages.unknownTitle;
    }
  }

  String _getMessage() {
    switch (errorType) {
      case LocationError.serviceDisabled:
        return LocationMessages.serviceDisabledMessage;
      case LocationError.permissionDenied:
        return LocationMessages.permissionDeniedMessage;
      case LocationError.permissionDeniedForever:
        return LocationMessages.permissionDeniedForeverMessage;
      case LocationError.timeout:
        return LocationMessages.timeoutMessage;
      case LocationError.unknown:
        return LocationMessages.unknownMessage;
    }
  }


  bool _canRetry() {
    // 재시도 가능한 에러 타입
    return errorType == LocationError.permissionDenied ||
        errorType == LocationError.timeout ||
        errorType == LocationError.unknown;
  }
}
