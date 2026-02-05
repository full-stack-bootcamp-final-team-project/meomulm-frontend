import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/providers/filter_provider.dart';
import 'package:meomulm_frontend/core/providers/notification_provider.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/providers/accommodation_provider.dart';
import 'package:meomulm_frontend/features/map/presentation/providers/map_provider.dart';
import 'package:meomulm_frontend/features/my_page/presentation/providers/my_reservation_provider.dart';
import 'package:meomulm_frontend/features/my_page/presentation/providers/user_profile_provider.dart';
import 'package:meomulm_frontend/features/reservation/presentation/providers/reservation_form_provider.dart';
import 'package:meomulm_frontend/features/reservation/presentation/providers/reservation_provider.dart';
import 'package:provider/provider.dart';

import 'core/constants/config/env_config.dart';
import 'core/providers/theme_provider.dart';
import 'core/router/app_router.dart';
import 'features/accommodation/data/datasources/accommodation_api_service.dart';
import 'features/accommodation/data/datasources/home_accommodation_service.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/home/presentation/providers/home_provider.dart';



class MeomulmApp extends StatefulWidget {
  final AuthProvider authProvider;

  const MeomulmApp({
    super.key,
    required this.authProvider,
  });

  @override
  State<MeomulmApp> createState() => _MeomulmAppState();
}

class _MeomulmAppState extends State<MeomulmApp> {
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _listenForLinks();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      if (auth.token != null) {
        Provider.of<NotificationProvider>(context, listen: false).connect(auth.token!);
      }
    });
  }

  void _listenForLinks() {
    final appLinks = AppLinks();

    // 앱이 백그라운드 → 포그라운드로 돌아올 때 deeplink 수신
    _linkSubscription = appLinks.uriLinkStream.listen((Uri uri) {
      debugPrint('실행 중 deeplink URI 수신: $uri');

      final parsedPath = AppRouter.parseDeepLinkUri(uri);
      if (parsedPath != null) {
        debugPrint('파싱된 경로 → GoRouter.push: $parsedPath');
        AppRouter.router.push(parsedPath);
      }
    }, onError: (e) {
      debugPrint('deeplink stream 에러: $e');
    });
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => AccommodationProvider()),
        ChangeNotifierProvider(create: (_) => FilterProvider()),
        ChangeNotifierProvider.value(value: widget.authProvider),
        ChangeNotifierProvider(create: (_) => UserProfileProvider()),
        ChangeNotifierProvider(create: (_) => MapProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => ReservationProvider()),
        ChangeNotifierProvider(create: (_) => ReservationFormProvider()),
        ChangeNotifierProvider(create: (_) => MyReservationProvider()),
      ],
      child: Consumer2<ThemeProvider, AuthProvider>(
        builder: (context, themeProvider, auth, child) {
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