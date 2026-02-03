import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/providers/notification_provider.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/providers/accommodation_provider.dart';
import 'package:meomulm_frontend/features/map/presentation/providers/map_provider.dart';
import 'package:meomulm_frontend/features/my_page/presentation/providers/user_profile_provider.dart';
import 'package:meomulm_frontend/features/reservation/presentation/providers/reservation_form_provider.dart';
import 'package:meomulm_frontend/features/reservation/presentation/providers/reservation_provider.dart';
import 'package:provider/provider.dart';

import 'core/constants/config/env_config.dart';
import 'core/providers/theme_provider.dart';
import 'core/router/app_router.dart';
import 'features/accommodation/data/datasources/home_accommodation_service.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/home/presentation/providers/home_provider.dart';
import 'features/map/data/datasources/map_service.dart';

class MeomulmApp extends StatelessWidget {
  final AuthProvider authProvider;

  const MeomulmApp({
    super.key,
    required this.authProvider,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => AccommodationProvider()),
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider(create: (_) => UserProfileProvider()),
        ChangeNotifierProvider(create: (_) => MapProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider(HomeAccommodationService())),
        ChangeNotifierProvider(create: (_) => ReservationProvider()),
        ChangeNotifierProvider(create: (_) => ReservationFormProvider()),
      ],
      child: Consumer2<ThemeProvider, AuthProvider>(
        builder: (context, themeProvider, auth, child) {

          // 로그인 상태 확인 후 실시간 알림 연결
          if (auth.token != null) {
            // 프레임 렌더링 후 실행되도록 예약
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<NotificationProvider>().connect(auth.token!);
            });
          }

          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: EnvConfig.appName,
            theme: themeProvider.themeData,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}