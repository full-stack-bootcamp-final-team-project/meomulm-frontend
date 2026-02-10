import 'package:flutter/material.dart';

/// =====================
/// 여백(Spacing) 정의
/// =====================
class AppSpacing {
  AppSpacing._();

  static const double xxs = 2.0;
  static const double xs = 4.0;
  static const double s = 6.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double xxxl = 40.0;
  static const double xxxxl = 80.0;
}

/// =====================
/// 모서리 둥글기(Border Radius) 정의
/// =====================
class AppBorderRadius {
  AppBorderRadius._();

  static const double xs = 5.0;
  static const double sm = 8.0;
  static const double md = 10.0;
  static const double lg = 12.0;
  static const double xl = 14.0;
  static const double xxl = 16.0;
  static const double xxxl = 18.0;

  static BorderRadius circular(double radius) => BorderRadius.circular(radius);

  static const smallRadius = BorderRadius.all(Radius.circular(sm));
  static const mediumRadius = BorderRadius.all(Radius.circular(md));
  static const largeRadius = BorderRadius.all(Radius.circular(lg));
}

/// =====================
/// 테두리 굵기(Border Width) 정의
/// =====================
class AppBorderWidth {
  AppBorderWidth._();

  static const double sm = 0.5;
  static const double md = 1.0;
  static const double lg = 2.0;

}

/// =====================
/// 그림자(Shadow) 정의
/// =====================
class AppShadows {
  AppShadows._();

  static const small = [
    BoxShadow(
      color: Color(0x26000000),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  static const medium = [
    BoxShadow(
      color: Color(0x26000000),
      blurRadius: 6,
      offset: Offset(0, 3),
    ),
  ];

  static const large = [
    BoxShadow(
      color: Color(0x26000000),
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];

  static const card = [
    BoxShadow(
      color: Color(0x26000000),
      blurRadius: 5,
      offset: Offset(3, 3),
    ),
    BoxShadow(
      color: Color(0x26000000),
      blurRadius: 5,
      offset: Offset(-3, -3),
    ),
    BoxShadow(
      color: Color(0x26000000),
      blurRadius: 5,
      offset: Offset(-3, 3),
    ),
    BoxShadow(
      color: Color(0x26000000),
      blurRadius: 5,
      offset: Offset(3, -3),
    ),
  ];

  static const bottomNav = [
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, -4),
      blurRadius: 5,
      spreadRadius: 0,
    ),
  ];
}