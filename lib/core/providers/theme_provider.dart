import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';


// 시간대 기반 테마
enum TimeThemeType {
  sunset, //메인
  dawn,
  day,
  night,
}

class ThemeProvider with ChangeNotifier {
  TimeThemeType _currentTheme = TimeThemeType.sunset;

  TimeThemeType get currentTheme => _currentTheme;

  LinearGradient get backgroundGradient {
    switch (_currentTheme) {
      case TimeThemeType.dawn:
        return AppGradients.dawn;
      case TimeThemeType.day:
        return AppGradients.day;
      case TimeThemeType.sunset:
        return AppGradients.sunset;
      case TimeThemeType.night:
        return AppGradients.night;
    }
  }

  ThemeData get themeData => _buildTheme();
  ThemeData _buildTheme() {
    return ThemeData(
        useMaterial3: true,
        fontFamily: 'Inter',
        scaffoldBackgroundColor: AppColors.white
    );
  }

  void changeTheme(TimeThemeType theme) {
    _currentTheme = theme;
    notifyListeners();
  }

  // 시간대 자동 변경
  void changeThemeByTime() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 9) {
      changeTheme(TimeThemeType.dawn);
    } else if (hour >= 9 && hour < 17) {
      changeTheme(TimeThemeType.day);
    } else if (hour >= 17 && hour < 20) {
      changeTheme(TimeThemeType.sunset);
    } else {
      changeTheme(TimeThemeType.night);
    }
  }
}