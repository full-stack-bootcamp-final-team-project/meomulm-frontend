import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

import 'app.dart';
import 'core/constants/config/env_config.dart';
import 'features/auth/presentation/providers/auth_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // .env.development 파일 로드
  await dotenv.load(fileName: ".env.development");

  if (EnvConfig.isDevelopment) EnvConfig.printEnvInfo();

  // 카카오맵 초기화
  AuthRepository.initialize(appKey: EnvConfig.kakaoMapKey);

  // AuthProvider 생성 및 저장된 사용자 로드
  final authProvider = AuthProvider();

  runApp(MeomulmApp(authProvider: authProvider));
}