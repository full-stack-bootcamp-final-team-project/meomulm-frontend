import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

import 'app.dart';
import 'core/constants/config/env_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env.development");

  if (EnvConfig.isDevelopment) EnvConfig.printEnvInfo();
  AuthRepository.initialize(appKey: EnvConfig.kakaoMapKey);

  runApp(MeomulmApp());
}
