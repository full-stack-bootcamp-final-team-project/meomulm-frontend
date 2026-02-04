import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:kakao_map_sdk/kakao_map_sdk.dart';
import 'package:naver_login_sdk/naver_login_sdk.dart';

import 'app.dart';
import 'core/constants/config/env_config.dart';
import 'features/auth/presentation/providers/auth_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // .env.development 파일 로드
  await dotenv.load(fileName: ".env.development");

  if (EnvConfig.isDevelopment) EnvConfig.printEnvInfo();

  // ✅ 추가: 모바일(Android/iOS) 여부 체크
  final bool isMobile =
      !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  // ─── Stripe SDK 초기화 (모바일에서만) ───
  if (isMobile) {
    final stripeKey = dotenv.env['STRIPE_PUBLISHABLE_KEY'];

    if (stripeKey != null && stripeKey.isNotEmpty) {
      Stripe.publishableKey = stripeKey;
      Stripe.merchantIdentifier = 'merchant.com.example';
      Stripe.urlScheme = 'flutterstripe';

      await Stripe.instance.applySettings();

      debugPrint('Stripe.publishableKey = ${Stripe.publishableKey}');
    } else {
      debugPrint('⚠️ STRIPE_PUBLISHABLE_KEY 없음 → Stripe 초기화 생략');
    }
  }

  // 모바일(Android/iOS) 환경에서만 Kakao Map 초기화
  // 수정된 부분: 웹이 아니고, 모바일(Android/iOS)일 때만 실행
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

  if (Platform.isAndroid || Platform.isIOS) {
    await NaverLoginSDK.initialize(
      clientId: EnvConfig.naverLoginClientId,
      clientSecret: EnvConfig.naverLoginClientSecret,
      clientName: EnvConfig.naverLoginClientName,
    );
  }

  runApp(MeomulmApp(authProvider: authProvider));
}

