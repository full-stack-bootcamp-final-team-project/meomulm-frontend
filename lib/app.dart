import 'package:flutter/material.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/providers/accommodation_provider.dart';
import 'package:provider/provider.dart';

import 'core/constants/config/env_config.dart';
import 'core/providers/theme_provider.dart';
import 'core/router/app_router.dart';
import 'features/auth/presentation/providers/auth_provider.dart';

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
        ChangeNotifierProvider(create: (_) => AccommodationProvider()),
        ChangeNotifierProvider.value(value: authProvider),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
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