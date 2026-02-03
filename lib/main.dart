import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:kakao_map_sdk/kakao_map_sdk.dart';
import 'package:app_links/app_links.dart';

import 'app.dart';
import 'core/constants/config/env_config.dart';
import 'core/router/app_router.dart';
import 'features/auth/presentation/providers/auth_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env.development");

  if (EnvConfig.isDevelopment) EnvConfig.printEnvInfo();

  if (!kIsWeb) {
    if (Platform.isAndroid || Platform.isIOS) {
      await KakaoMapSdk.instance.initialize(EnvConfig.kakaoNativeKey);
    } else {
      debugPrint("PC(Windows/Mac) 환경: Kakao Map SDK 초기화 생략");
    }
  } else {
    debugPrint("Web 환경: Kakao Map SDK 초기화 생략");
  }

  // ---------------------------------------------------------------
  // 초기 deeplink 캐치 (앱이 완전히 종료된 상태에서 링크로 열린 경우)
  // ---------------------------------------------------------------
  try {
    final appLinks = AppLinks();
    final Uri? initialUri = await appLinks.getInitialLink();
    if (initialUri != null) {
      debugPrint('🔗 초기 deeplink URI 캐치: $initialUri');
      final parsedPath = AppRouter.parseDeepLinkUri(initialUri);
      if (parsedPath != null) {
        debugPrint('🔗 파싱된 경로: $parsedPath');
        AppRouter.pendingDeepLink = parsedPath;
      }
    }
  } catch (e) {
    debugPrint('⚠️ 초기 deeplink 캐치 실패: $e');
  }

  final authProvider = AuthProvider();

  KakaoSdk.init(
    nativeAppKey: EnvConfig.kakaoLoginNativeKey,
  );

  debugPrint('KakaoSdk.appKey = ${KakaoSdk.appKey}');

  runApp(MeomulmApp(authProvider: authProvider));
}