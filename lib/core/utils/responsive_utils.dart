import 'package:flutter/cupertino.dart';
import 'package:meomulm_frontend/core/constants/config/app_config.dart';

/// =====================
/// 반응형
/// =====================
class ResponsiveUtils {
  ResponsiveUtils._();

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < AppBreakpoints.mobile;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= AppBreakpoints.mobile &&
        width < AppBreakpoints.desktop;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= AppBreakpoints.desktop;
  }
}
