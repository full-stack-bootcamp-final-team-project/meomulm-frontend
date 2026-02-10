import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_dimensions.dart';

/// =====================
/// 카드 스타일 정의
/// =====================
class AppCardStyles {
  AppCardStyles._();

  //  카드
  static BoxDecoration card = BoxDecoration(
    color: Colors.white,
    borderRadius: AppBorderRadius.mediumRadius,
    border: Border.all(color: AppColors.gray4),
    boxShadow: AppShadows.medium,
  );
}

/// =====================
/// 그라디언트 정의
/// =====================
class AppGradients {
  AppGradients._();

  // 메인 그라디언트 (노을)
  static const sunset = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment(0.0, -0.2),
    colors: [
      AppColors.main,
      AppColors.sub,
    ],
    stops: [0.0, 1.0],
  );

  // 새벽 그라디언트
  static const dawn = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment(0.0, -0.2),
    colors: [
      AppColors.dawnMain,
      AppColors.dawnSub,
    ],
    stops: [0.0, 0.6],
  );

  // 낮 그라디언트
  static const day = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment(0.0, -0.2),
    colors: [
      AppColors.dayMain,
      AppColors.daySub,
    ],
    stops: [0.0, 0.6],
  );

  // 밤 그라디언트
  static const night = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment(0.0, -0.2),
    colors: [
      AppColors.nightMain,
      AppColors.nightSub,
    ],
    stops: [0.0, 0.5],
  );

  /// 현재 시간 기준 메인 그라디언트
  static LinearGradient byTime({DateTime? debugTime}) {
    final now = debugTime ?? DateTime.now();
    final hour = now.hour;

    if (hour >= 5 && hour < 11) {
      return dawn;
    } else if (hour >= 11 && hour < 17) {
      return day;
    } else if (hour >= 17 && hour < 21) {
      return sunset;
    } else {
      return night;
    }
  }
}