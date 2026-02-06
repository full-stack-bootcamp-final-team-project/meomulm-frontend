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
  const MeomulmApp({super.key, required this.authProvider});

  @override
  State<MeomulmApp> createState() => _MeomulmAppState();
}

class _MeomulmAppState extends State<MeomulmApp> {
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _listenForLinks();
    widget.authProvider.loadSavedToken();
  }

  void _listenForLinks() {
    final appLinks = AppLinks();
    _linkSubscription = appLinks.uriLinkStream.listen((Uri uri) {
      final parsedPath = AppRouter.parseDeepLinkUri(uri);
      if (parsedPath != null) AppRouter.router.push(parsedPath);
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
          // build가 끝난 직후 실행되도록 토큰 유무에 따른 처리
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final notification = context.read<NotificationProvider>();
            if (auth.isLoggedIn) {
              notification.connect(auth.token!);
            } else {
              notification.disconnect();
            }
          });

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