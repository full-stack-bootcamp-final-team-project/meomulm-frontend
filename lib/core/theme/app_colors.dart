import 'package:flutter/material.dart';

/// =====================
/// 색상 정의
/// =====================
class AppColors {
  AppColors._();

  // =========== 메인 시간 대 색상 ===========
  // 노을
  static const main = Color(0xFF9D96CA);
  static const sub = Color(0xFFE56E50);
  // ========================================

  // ========== 메인 외 시간 대 별 색상 ==========
  // 새벽
  static const dawnMain = Color(0xFF5699CD);
  static const dawnSub = Color(0xFFFFECC9);

  // 낮
  static const dayMain = Color(0xFF91CFFF);
  static const daySub = Color(0xFFE7EFF0);

  // 밤
  static const nightMain = Color(0xFF3A586E);
  static const nightSub = Color(0xFF4C1D47);
  // ============================================

  // Menu Colors
  static const menuSelected = Color(0xFF009DFF);
  static const selectedLight = Color(0xFFCCEBFF);
  static const cancelled = Color(0xFFFF2A2A);
  static const cancelledLight = Color(0xFFFFBEBE);

  static const ratingColor = Color(0xFFFFC300);
  static const ratingGradientColor = Color(0xFFFBF3E8);
  static const success = Color(0xFF34C759);
  static const error = Color(0xFFFF3B30);

  // Button Colors
  static const disabled = Color(0xFFDEDDEA);
  static const onPressed = Color(0xFF6F63C0);

  // Social Login Button Colors
  static const kakaoBg = Color(0xFFFEE500);
  static const kakaoIcon = Color(0xFF000000);
  static const naverBg = Color(0xFF03A94D);
  static const naverIcon = Color(0xFFFFFFFF);

  // backdrop Colors
  static const backdrop = Color(0x99161616);

  // Grayscale
  static const black = Color(0xFF111111);
  static const gray1 = Color(0xFF303030);
  static const gray2 = Color(0xFF8B8B8B);
  static const gray3 = Color(0xFFC1C1C1);
  static const gray4 = Color(0xFFD2D2D2);
  static const gray5 = Color(0xFFEDEDED);
  static const gray6 = Color(0xFFF0F4FF);
  static const white = Color(0xFFFFFFFF);
  static const border = Color(0xFF888888);
}