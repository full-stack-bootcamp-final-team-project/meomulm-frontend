import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:kakao_map_sdk/kakao_map_sdk.dart';

import 'app.dart';
import 'core/constants/config/env_config.dart';
import 'features/auth/presentation/providers/auth_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // .env.development 파일 로드
  await dotenv.load(fileName: ".env.development");

  if (EnvConfig.isDevelopment) EnvConfig.printEnvInfo();

  // if (!kIsWeb) {
  //   await KakaoMapSdk.instance.initialize(EnvConfig.kakaoNativeKey);
  // }


  // AuthProvider 생성 및 저장된 사용자 로드
  final authProvider = AuthProvider();

  runApp(MeomulmApp(authProvider: authProvider));
}