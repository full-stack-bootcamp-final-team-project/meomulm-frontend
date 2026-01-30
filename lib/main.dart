import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_map_sdk/kakao_map_sdk.dart';

import 'app.dart';
import 'core/constants/config/env_config.dart';
import 'features/auth/presentation/providers/auth_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // .env.development 파일 로드
  await dotenv.load(fileName: ".env.development");

  // 커스텀 API URL 로드 (개발자 설정 화면에서 저장한 값)
  await EnvConfig.loadCustomApiBaseUrl();

  if (EnvConfig.isDevelopment) EnvConfig.printEnvInfo();

  // 모바일(Android/iOS) 환경에서만 Kakao Map 초기화
  if (!kIsWeb) {
    await KakaoMapSdk.instance.initialize(EnvConfig.kakaoNativeKey);
  } else {
    debugPrint("Web 환경: Kakao Map SDK 초기화 생략");
  }

  final authProvider = AuthProvider();

  runApp(MeomulmApp(authProvider: authProvider));
}
