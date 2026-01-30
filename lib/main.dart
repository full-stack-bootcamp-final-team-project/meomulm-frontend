import 'dart:io'; // [중요] Platform 확인을 위해 이 줄을 꼭 추가해야 합니다.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_map_sdk/kakao_map_sdk.dart';

import 'app.dart';
import 'core/constants/config/env_config.dart';
import 'features/auth/presentation/providers/auth_provider.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 2. HTTP 인증서 우회 설정 적용
  HttpOverrides.global = MyHttpOverrides();

  // .env.development 파일 로드
  await dotenv.load(fileName: ".env.development");

  if (EnvConfig.isDevelopment) EnvConfig.printEnvInfo();

  // 모바일(Android/iOS) 환경에서만 Kakao Map 초기화
  // if (!kIsWeb) {
  //   await KakaoMapSdk.instance.initialize(EnvConfig.kakaoNativeKey);
  // } else {
  //   debugPrint("Web 환경: Kakao Map SDK 초기화 생략");
  // }

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

  runApp(MeomulmApp(authProvider: authProvider));
}
