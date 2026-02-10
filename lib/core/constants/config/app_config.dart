/// =====================
/// 화면 크기 분기점(Breakpoints)
/// =====================
class AppBreakpoints {
  AppBreakpoints._();

  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
}


/// =====================
/// 애니메이션 지속시간
/// =====================
class AppDurations {
  AppDurations._();

  static const fast = Duration(milliseconds: 150);
  static const medium = Duration(milliseconds: 300);
  static const slow = Duration(milliseconds: 500);
  static const snackbar = Duration(milliseconds: 1200);
}


/// =====================
/// AppBar 관련 레이아웃 상수
/// =====================
class AppBarDimensions {
  AppBarDimensions._();

  static const double appBarHeight = 70;
  static const double searchBarHeight = 48;
  static const double dividerHeight = 1;
}


/// =====================
/// Bottom Action Button 관련 레이아웃 상수
/// =====================
class BottomActionButtonDimensions {
  BottomActionButtonDimensions._();

  static const double padding = 20;
  static const double height = 50;
  static const double widthPercentage = 0.9;
}

