import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:kakao_map_sdk/kakao_map_sdk.dart';

import 'app.dart';
import 'core/constants/config/env_config.dart';
import 'features/auth/presentation/providers/auth_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // .env.development 파일 로드
  await dotenv.load(fileName: ".env.development");

  if (EnvConfig.isDevelopment) EnvConfig.printEnvInfo();

  // ─── Stripe SDK 초기화 ───
  // 테스트 키: pk_test_xxxxx  (Stripe Dashboard > Developers > API Keys)
  // .env.development 에 STRIPE_PUBLISHABLE_KEY=pk_test_xxxxx 로 관리하면 깔끔
  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? 'pk_test_xxxxx';

  debugPrint('Stripe.publishableKey = ${Stripe.publishableKey}');

  // 모바일(Android/iOS) 환경에서만 Kakao Map 초기화
  if (!kIsWeb) {
    if (Platform.isAndroid || Platform.isIOS) {
      await KakaoMapSdk.instance.initialize(EnvConfig.kakaoNativeKey);
    } else {
      debugPrint("PC(Windows/Mac) 환경: Kakao Map SDK 초기화 생략");
    }
  } else {
    debugPrint("Web 환경: Kakao Map SDK 초기화 생략");
  }

  final authProvider = AuthProvider();

  // ✅ Kakao SDK 초기화 먼저
  KakaoSdk.init(
    nativeAppKey: EnvConfig.kakaoLoginNativeKey,
  );

  debugPrint('KakaoSdk.appKey = ${KakaoSdk.appKey}');

  runApp(MeomulmApp(authProvider: authProvider));
}